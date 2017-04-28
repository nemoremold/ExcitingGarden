//
//  ViewController.swift
//  Excited
//
//  Created by Emoin Lam on 29/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit

/*
 MainSceneViewController Functionalities
    - Manages the main view presenting information of a certain plant
    - Manages the data passing between related views
*/
class MainSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var ShowPlant: UIButton!
    @IBOutlet weak var ShowPrivateSchedule: UIButton!
    @IBOutlet weak var ShowInteraction: UIButton!
    @IBOutlet weak var SubviewController: UIView!
    @IBOutlet weak var PlantDisplayer: UIView!
    @IBOutlet weak var PrivateSchedule: UITableView!
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
        // Do any additional setup after loading the view, typically from a nib.
        self.PrivateSchedule.delegate = self
        self.PrivateSchedule.dataSource = self
        speed_f = 0.25
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        SubviewController.bringSubview(toFront: PlantDisplayer)
    }
    
    @IBAction func DisplayPrivateSchedule(_ sender: UIButton) {
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


}
    
