//
//  ViewController.swift
//  Excited
//
//  Created by Emoin Lam on 29/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import CoreLocation
/*
 MainSceneViewController Functionalities
    - Manages the main view presenting information of a certain plant
    - Manages the data passing between related views
*/
class MainSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var ShowPlant: UIButton!
    @IBOutlet weak var ShowPrivateSchedule: UIButton!
    @IBOutlet weak var ShowInteraction: UIButton!
    @IBOutlet weak var SubviewController: UIView!
    @IBOutlet weak var PlantDisplayer: UIView!
    @IBOutlet weak var PrivateSchedule: UITableView!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var TempLabel: UILabel!
    @IBAction func keyBoards(_ sender: Any) {
    }
    @IBOutlet weak var PlantName: UILabel!
    
    var leftViewController: LeftTableViewController?
    
    private var plantManager = PlantManager()
    private var displayedPlantID = Int(0)
    private var displayedPlant = Plant(name: "Default", ID: -1, plantType: .Default)
    var speed_f:double_t?//滑动的速度
    var condition_f:CGFloat?
    let screenW = UIScreen.main.bounds.width
    var maxWidth: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrivateSchedule.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        self.PrivateSchedule.delegate = self
        self.PrivateSchedule.dataSource = self
        speed_f = 0.25
        //发送通知消息
        scheduleNotification(itemID: 12345);
        //PrivateSchedule.deleteSections([0], with: .none)
        /*
        let countRows = PrivateSchedule.numberOfRows(inSection: 0)
        for _ in 0 ..< countRows {
            PrivateSchedule.deleteRows(at: PrivateSchedule.indexPathsForVisibleRows!, with: .none)
        }
        */
        
        //self.view.addSubview(self.PrivateSchedule)
        //self.PrivateSchedule.tableFooterView = UIView()
        if displayedPlant.getID() == -1 {
            loadSamples()
        }
        PlantName.text = displayedPlant.getName();
        //print("VIEWDIDLOAD PLACE")
        self.leftViewController = LeftTableViewController()
        self.view.addSubview((self.leftViewController?.view)!)
        //将抽屉视图隐藏掉
        self.leftViewController?.view.isHidden = true
        //self.mainViewController?.view.isHidden = true
        
        //添加屏幕边缘手势
        let pan = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(edgPanGesture(_:)))
        pan.edges = UIRectEdge.left //从左边缘开始滑动
        self.view.addGestureRecognizer(pan)
        initLocation()
        getCurrentWeatherData();
    }
    ///////////////////////////////推送啊啊啊啊啊///////////////////////////////////
    func scheduleNotification(itemID:Int){
        //如果已存在该通知消息，则先取消
        cancelNotification(itemID: itemID)
        
        //创建UILocalNotification来进行本地消息通知
        let localNotification = UILocalNotification()
        let pushTime: Float = 06*56*60
        let date = NSDate()
        let dateFormatter = DateFormatter()
        //日期格式为“时，分，秒”
        dateFormatter.dateFormat = "HH,mm,ss"
        //设备当前的时间（24小时制）
        let strDate = dateFormatter.string(from: date as Date)
        //将时、分、秒分割出来，放到一个数组
        let dateArr = strDate.components(separatedBy: ",")
        //统一转化成秒为单位
        let hour = ((dateArr[0] as NSString).floatValue)*60*60
        let minute = ((dateArr[1] as NSString).floatValue)*60
        let second = (dateArr[2] as NSString).floatValue
        var newPushTime = Float()
        if hour > pushTime {
            newPushTime = 24*60*60-(hour+minute+second)+pushTime
        } else {
            newPushTime = pushTime-(hour+minute+second)
        }
        let fireDate = NSDate(timeIntervalSinceNow: TimeInterval(newPushTime))
        
        //推送时间（设置为30秒以后）
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 30) as Date
        //推送时间为每天早上7点整
        //localNotification.fireDate = fireDate as Date
        
        //时区
        localNotification.timeZone = NSTimeZone.default
        //推送内容
        let new1 = "该给"
        let new2 = "浇水了"
        //let new3 = "晒太阳了"
        localNotification.alertBody = new1+"苹果花"+new2
        //声音
        localNotification.soundName = UILocalNotificationDefaultSoundName
        //额外信息
        localNotification.userInfo = ["ItemID":itemID]
        localNotification.applicationIconBadgeNumber += 1;
        localNotification.repeatInterval = NSCalendar.Unit.day
        //添加一个字典类型的info，主要就是为了记录通知的标识，这里用存了一个key名
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    //取消通知消息
    func cancelNotification(itemID:Int){
        //通过itemID获取已有的消息推送，然后删除掉，以便重新判断
        let existingNotification = self.notificationForThisItem(itemID: itemID) as UILocalNotification?
        if existingNotification != nil {
            //如果existingNotification不为nil，就取消消息推送
            UIApplication.shared.cancelLocalNotification(existingNotification!)
        }
    }
    
    //通过遍历所有消息推送，通过itemid的对比，返回UIlocalNotification
    func notificationForThisItem(itemID:Int)-> UILocalNotification? {
        let allNotifications = UIApplication.shared.scheduledLocalNotifications
        for notification in allNotifications! {
            let info = notification.userInfo as! [String:Int]
            let number = info["ItemID"]
            if number != nil && number == itemID {
                return notification as UILocalNotification
            }
        }
        return nil
    }
////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        PlantName.text = displayedPlant.getName();
        //print("VIEWWILLAPPEAR PLACE")
        displayedPlant.sortSchedules()
        rearrange()
        /*
        var reloadIndexPaths = [IndexPath]()
        for index in 0 ..< tableView(PrivateSchedule, numberOfRowsInSection: 0) {
            reloadIndexPaths += [IndexPath(row: index, section: 0)]
        }
        PrivateSchedule.reloadRows(at: reloadIndexPaths, with: .none)
        */
        PrivateSchedule.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func DisplayPlantInformation(_ sender: UIButton) {
        PrivateSchedule.isHidden = true;
        SubviewController.bringSubview(toFront: PlantDisplayer)
    }
    
    @IBAction func DisplayPrivateSchedule(_ sender: UIButton) {
        PrivateSchedule.isHidden = false;
        SubviewController.bringSubview(toFront: PrivateSchedule)
    }
    
    // Get the data from plant adding views
    @IBAction func unwindToMainScene(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? AddPlantViewController else {
            return
        }
        let plantType = sourceViewController.getNewPlantType()
        let plantName = sourceViewController.getNewPlantName()
        
        addNewPlant(name: plantName, type: plantType)
    }
    
    
    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("QUERYED!")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPlant.countSchedules()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        //print("\(displayedPlant.countSchedules()) \(indexPath.row) \(tableView.numberOfRows(inSection: 0))")
        let index = indexPath.row
        
        let schedule = displayedPlant.getSchedule(id: displayedPlant.getSortedScheduleIDByRank(id: index))
        
        cell.PlantName.text = displayedPlant.getName()
        cell.ActionName.text = schedule.getTask()
        cell.TimeLabel.text = schedule.getTime()
        
        return cell
    }
    
    
    // MARK: Private Methods
    private func loadSamples() {
        var _ = plantManager.addPlant(name: "TRY1", type: .AppleFlower)
        var time = Time(day: 1, month: 5, year: 2017, hour: 22, minute: 0)
        var schedule = Schedule(time: time, task: .Watering)
        var errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        if errorCheck == false {
            return
        }
        time = Time(day: 1, month: 5, year: 2017, hour: 12, minute: 0)
        schedule = Schedule(time: time, task: .Watering)
        if errorCheck == false {
            return
        }
        errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        _ = plantManager.addPlant(name: "TRY2", type: .AppleFlower)
        for _ in 0 ..< 20 {
            time = Time(day: 1, month: 5, year: 2017, hour: 21, minute: 0)
            schedule = Schedule(time: time, task: .Watering)
            errorCheck = plantManager.addSchedule(id: 1, schedule: schedule)
            if errorCheck == false {
                return
            }
        }
        displayedPlantID = 1
        displayedPlant = plantManager.getPlantByID(id: displayedPlantID)
    }
    
    private func addNewPlant(name: String, type: PlantType) {
        let newPlantID = plantManager.addPlant(name: name, type: type)
        let time = Time(day: 1, month: 5, year: 2017, hour: 22, minute: 0)
        let schedule = Schedule(time: time, task: .Watering)
        let errorCheck = plantManager.addSchedule(id: newPlantID, schedule: schedule)
        if errorCheck == false {
            return
        }
        displayedPlantID = newPlantID
        displayedPlant = plantManager.getPlantByID(id: displayedPlantID)
        
        rearrange()
        //print("\(tableView(PrivateSchedule, numberOfRowsInSection: 0)) \(displayedPlantID)")
        //let newIndexPath = IndexPath(row: 0, section: 0)
        //PrivateSchedule.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    // Every time the schedules are changed, rearrange the cells
    private func rearrange() {
        let countRows = PrivateSchedule.numberOfRows(inSection: 0)
        let newRowsCount = displayedPlant.countSchedules()
        var disparity = newRowsCount - countRows
        
        if disparity == 0 {
            return
        }
        else if disparity > 0 {
            var tmp = [IndexPath]()
            for Index in 0 ..< disparity {
                tmp += [IndexPath(row: countRows + Index, section: 0)]
            }
            PrivateSchedule.insertRows(at: tmp, with: .none)
        }
        else {
            var tmp = [IndexPath]()
            disparity = -disparity
            for index in 0 ..< disparity {
                tmp += [IndexPath(row: countRows - 1 - index, section: 0)]
            }
            PrivateSchedule.deleteRows(at: tmp, with: .none)
        }
    }
    
    // MARK: Navigation
    // When a segue is to be carried out, the method is invoked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowOverallSchedule":
            guard let showOverallScheduleViewController = segue.destination as? OverallSchedule else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            showOverallScheduleViewController.transferredPlantManager = plantManager
            break
            
        default:
            print("Default")
        }
    }
    
    //滑动手势
    @objc private func edgPanGesture(_ pan:UIScreenEdgePanGestureRecognizer){
        //print("left edgeswipe ok")
        self.leftViewController?.view.isHidden = false
        
        //手指触摸的x位置
        let offsetX = pan.translation(in: pan.view).x
        //限制视图的变化范围是宽度的0.75
        maxWidth = screenW * 0.75
        
        //把抽屉栏放在主视图左边，设置主视图中心为视角
        leftViewController?.view.transform =  CGAffineTransform(translationX: -self.screenW, y: 0)
        
        if pan.state == UIGestureRecognizerState.changed && offsetX <= maxWidth {
            //主视图向右移动
            self.view.transform = CGAffineTransform(translationX: max(offsetX, 0), y: 0)
        }
        else if pan.state == UIGestureRecognizerState.ended
            || pan.state == UIGestureRecognizerState.cancelled
            || pan.state == UIGestureRecognizerState.failed {
            
            //移动大于屏幕宽度的0.35，打开侧边栏
            if offsetX > screenW * 0.35 {
                
                openLeftMenu()
                
            } else {//不然就关闭侧边栏
                
                closeLeftMenu()
            }
        }
        //*/
    }
    //打开左侧菜单
    private func openLeftMenu() {
        
        //限制视图的变化范围是宽度的0.75
        maxWidth = screenW * 0.75
        
        UIView.animate(withDuration: self.speed_f!, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.view.transform = CGAffineTransform(translationX: self.maxWidth, y: 0)
            
            
        }, completion: {
            
            (finish: Bool) -> () in
            
            self.view.addSubview(self.coverBtn)
            
        })
    }
    
    //关闭左侧菜单
    @objc private func closeLeftMenu() {
        
        UIView.animate(withDuration: self.speed_f!, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            //self.leftViewController?.view.transform = CGAffineTransform(translationX: -self.screenW, y: 0)
            self.view.transform = CGAffineTransform.identity
            
        }, completion: {
            
            (finish: Bool) -> () in
            
            self.coverBtn.removeFromSuperview()
            
        })
    }
    //灰色背景按钮
    private lazy var coverBtn: UIButton = {
        
        let btn = UIButton(frame: (self.view.bounds))
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(closeLeftMenu), for: .touchUpInside)
        btn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCloseLeftMenu(_:))))
        
        return btn
        
    }()
    //遮盖按钮手势
    @objc private func panCloseLeftMenu(_ pan: UIPanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        if offsetX > 0 {return}
        
        if pan.state == UIGestureRecognizerState.changed && offsetX >= -maxWidth {
            
            let distace = maxWidth + offsetX
            
            self.view.transform = CGAffineTransform(translationX: distace, y: 0)
            leftViewController?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            
        } else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            
            if offsetX > screenW * 0.35 {
                
                openLeftMenu()
                
            } else {
                
                closeLeftMenu()
            }
            
        }
        
    }




///////////////////////自动定位信息／／／／／／／／／／／／／／／／／／／／／／
//定位获取的城市名称
var city: String = ""
//用来获取温度信息的地址
var CityName: String = ""
//保存获取到的本地位置
var currLocation : CLLocation!
//用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
let locationManager : CLLocationManager = CLLocationManager()

func initLocation() {
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    //设备使用电池供电时最高的精度
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
    locationManager.distanceFilter = kCLLocationAccuracyKilometer
    locationManager.startUpdatingLocation()
    //处理位置信息
    self.CityTextField.borderStyle = UITextBorderStyle.none
    
    if(self.city != ""){
        self.CityTextField.text = (self.city) as String;
        
    }
    else{
        self.CityTextField.text = ("shanghai")//默认地址是上海，点击可以更改，但是更改后再获取还没实现。。。。。。。
        self.CityTextField.keyboardType = UIKeyboardType.asciiCapable
        self.CityTextField.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        /////////当文本框内容被改变时，重新获取文本框输入信息
    }
    self.CityName = self.CityTextField.text!
    /*
    if(self.CityName=="" || self.CityName=="自动定位失败，请手动输入" ){
        self.CityName = "shanghai"
    }
    self.CityTextField.text = self.CityName*/
    print(self.CityName)
    print("                                     okoookokkokokokkkk")
}
//MARK:- 实现CLLocationManagerDelegate协议
func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    print("locationManagerokokkokokokokoko")
    currLocation = locations.last as! CLLocation
    print(currLocation.coordinate.longitude)
    print(currLocation.coordinate.latitude)
    let local: String = LonLatToCity()
    print(local)
}
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //获取失败，可能是关闭了定位服务
    print("locationManager is error error error")
    
}
///将经纬度转换为城市名
func LonLatToCity()->String {
    
    print("LonLatToCity()has been used")
    let geocoder: CLGeocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
        
        
        if(error == nil)//成功
            
        {
            let array = placemark! as NSArray
            let mark = array.firstObject as! CLPlacemark
            //这个是城市
            let TheCity: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! NSString
            let citynameStr = TheCity.replacingOccurrences(of: "市", with: "")
            self.city = citynameStr as String
            
            /*
             //这个是国家
             
             let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
             
             //这个是国家的编码
             
             let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
             
             //这是街道位置
             
             
             let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
             
             //这是具体位置
             
             let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
             
             //这是省
             
             var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
             
             //这是区
             
             let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
             */
            
        }
        else
        {
            print("经纬度转换失败")
            print(error)
        }
    }
    
    return self.city
    
}

////////////////////////实时天气信息///////////////////////////////////
let apiId = "12b2817fbec86915a6e9b4dbbd3d9036"
//获取当前天气数据（北京）
func getCurrentWeatherData(){
    let Str1 = "http://api.openweathermap.org/data/2.5/weather?q="
    let Str2 =  "&units=metric&appid=\(apiId)"
    let urlStr = Str1+self.CityName+Str2
    let url = NSURL(string: urlStr)!
    guard let weatherData = NSData(contentsOf: url as URL) else { return }
    
    //将获取到的数据转为json对象
    let jsonData = try! JSON(data: weatherData as Data)
    
    //日期格式化输出
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    
    let temp = jsonData["main"]["temp"].number!
    //  在label上显示当前温度信息
    TempLabel.text = ("\(temp)°C")
    
    /*
     // print("城市：\(jsonData["name"].string!)")
     
     let weather = jsonData["weather"][0]["main"].string!
     // print("天气：\(weather)")
     let weatherDes = jsonData["weather"][0]["description"].string!
     // print("详细天气：\(weatherDes)")
     
     let humidity = jsonData["main"]["humidity"].number!
     // print("湿度：\(humidity)%")
     
     let pressure = jsonData["main"]["pressure"].number!
     // print("气压：\(pressure)hpa")
     
     let windSpeed = jsonData["wind"]["speed"].number!
     // print("风速：\(windSpeed)m/s")
     
     let lon = jsonData["coord"]["lon"].number!
     let lat = jsonData["coord"]["lat"].number!
     // print("坐标：[\(lon),\(lat)]")
     
     let timeInterval1 = TimeInterval(jsonData["sys"]["sunrise"].number!)
     let date1 = NSDate(timeIntervalSince1970: timeInterval1)
     // print("日出时间：\(dformatter.string(from: date1 as Date))")
     
     let timeInterval2 = TimeInterval(jsonData["sys"]["sunset"].number!)
     let date2 = NSDate(timeIntervalSince1970: timeInterval2)
     //   print("日落时间：\(dformatter.string(from: date2 as Date))")
     
     let timeInterval3 = TimeInterval(jsonData["dt"].number!)
     let date3 = NSDate(timeIntervalSince1970: timeInterval3)
     //  print("数据时间：\(dformatter.string(from: date3 as Date))")
     */
}

}

