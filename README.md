# ExcitingGarden
## Project EXCITED

### Product Name: Exciting Garden
### Product Version: 0.8

## Product Development History:
###
1.v0.1: product created by Emoin Lam
2.v0.2: product structure constructed by Emoin Lam
3.v0.3: data type designed and declared by Emoin Lam
4.v0.4: data type implemented by Emoin Lam
5.v0.5: basic data type interaction with views implemented by Emoin Lam
6.v0.6: add plant function implemented by Emoin Lam
7.v0.7: enabled plant adding and display by Emoin Lam
8.v0.8: basic functionality achieved by Emoin Lam

Problems To Be Solved
1. Layout bugs and constraints of the elements of views and views themselves
2. Auto scheduling and manual scheduling(lack database or static data to perform both the analysis and display)
3. Image resources(lack time to draw the images)
4. Side view to list current plants and to provide an interface for adding plants(the former one lack the certain technic to implement the side view which Emoin Lam has no time to achieve while the later one is replaced by another interactive button)
5. Interactive abilities yet to develop(proposal: abandoning the mission)
6. Plant display view(currently not modified but is easy to modify)

Emergent Task:
1. Get the data of ONE plant and make it a data source capable for development
2. Add THE SIDE VIEW


Process of project: 50%
Percentage of work: Emoin Lam(100%);


Product functionality Introduction
1.First of all, AppDelegate handles all the fundamental management of the application, with this we first go in to the LaunchScreenScene.
2.Then after loading the MainSceneView, control is handed over to MainSceneViewController which is under the view stack control of the first UINavigationController. This first UINavigationController need not be modified.
3.When MainSceneViewController.viewDidLoad is triggered, the view controller modifies one of its UITableView subview called PrivateSchedule. The PrivateSchedule displays the schedules of the plant that is currently chosen to be displayed. The cells of the PrivateScheduleTableView follow the protocol of ScheduleTableViewCell.
4.In the view of MainSceneViewController, three buttons are presented. The first button on top brings the UIView instantiate PlantDisplayer to front while the second button brings the UITableView PrivateSchedule to front, overlapping other views. PlantDisplayer is yet to be designed or implemented. The last button, however, pushes another view, namely the PlantListTableViewController, to the UINavigationController's view stack. The cells in PlantListTableViewController follow the protocol of NewPlantTableViewCell. Here should be listed all the plant types we set for users to add. By clicking on any cell in this view, a new UINavigationController instantiate called AddPlantNavigationViewController will be presented modally and the view to be presented will be the new UINavigationController's root view, AddPlantViewController.
5.In the AddPlantViewController view, we name the new plant as well as set the schedule of the plant which the later part of the function is now unavailable to implement because of the lack of database. Users can cancel the plant adding by clicking on the left bar button. Or they can add the plant after entering the name of the plant and the entered name is a non-empty String.
6.If the saveButton is clicked, the AddPlantViewController's UIViewController and the AddPlantNavigationViewController's UINavigationController will be dismissed and the data will unwind to MainSceneViewController to present the new plant. The new data will be added to the plantManager of MainSceneViewController.
7.When user clicked the right bar button of MainSceneViewController, namely the Schedule button, a show segue will be activated, invoking the prepare method. This method prepares the plantManager of the UITableViewController OverallSchedule, setting it the same as the plantManager of MainSceneViewController.  
8.OverallSchedule manages the total display of all schedules, its cells follow the protocol of ScheduleTableViewCell.
###
