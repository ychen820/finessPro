//
//  StepViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import MKRingProgressView
import CoreData
import Firebase
import FBSDKShareKit
class StepViewController: UIViewController,BLTManagerDelegate{
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var ringProgressView:MKRingProgressView!
    @IBOutlet weak var stepLabel:UILabel!
    var totalStep : TotalGoal?
    var shareNotified : Bool = false
    var bltManager : BLTManager?
    var ad : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var todayGoal : DailyGoal?
    var currentMonthEntry : Yearly?
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodaysGoal()
        getMonthEntity()
        ringProgressSetup()
        bltManager = BLTManager.shareInstance
        graphView.smoothDarkSetup()
        graphView.set([0], withLabels: [""])
        showWeeklyGraph()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        bltManager?.uiDelegate = self
        updateRingprogress()
        getTotalStep()
        
    }
    override func didSwitchScreen() {
       

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //MARK: - UI Setup
    func ringProgressSetup(){
        //ringProgressView = MKRingProgressView(frame: progressView.frame)
        ringProgressView.startColor = .red
        ringProgressView.endColor = .green
        ringProgressView.ringWidth = 10
        ringProgressView.progress = 0
    }
    func updateRingprogress(){
        if let todaygoal = self.todayGoal{
            let progress = Double(todaygoal.actualStep) / Double(todaygoal.goalstep)
            stepLabel.text = String(todaygoal.actualStep)
            ringProgressView.progress = progress
            if !todaygoal.achieved && progress >= 1{
                todaygoal.achieved = true
                shareScreenShotWithFb()
            }
        }
    }
    func shareScreenShotWithFb(){
        guard let screenShot = renderImageFromMap(view: self.view, frame: self.view.frame) else{
            return
        }
        shareNotified = true
        let fbsdkPhoto = FBSDKSharePhoto(image: screenShot, userGenerated: true)
        let fbsdkPhotoContent = FBSDKSharePhotoContent()
        fbsdkPhotoContent.photos = [fbsdkPhoto!]
        FBSDKShareDialog.show(from: self, with: fbsdkPhotoContent, delegate: nil)
    }
    //MARK: - CoreDate Methods
    func getTodaysGoal(){
        let todayBegin = NSCalendar.current.startOfDay(for: Date()) as NSDate
        print(todayBegin.description)
        let fetchRequest = DailyGoal.fetchRequest() as! NSFetchRequest<DailyGoal>
        fetchRequest.predicate = NSPredicate(format: "date == %@", todayBegin)
        do{
            let result = try ad.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty {
                guard let todayGoal = NSEntityDescription.insertNewObject(forEntityName: "DailyGoal", into: ad.persistentContainer.viewContext) as? DailyGoal else{return}
                todayGoal.date = todayBegin as Date
                todayGoal.goalstep = 10000
                ad.saveContext()
            }
            else{
                let todayGoal = result.first
                ad.saveContext()
                self.todayGoal = todayGoal
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    func getTotalStep(){
        let fetchRequest = TotalGoal.fetchRequest() as! NSFetchRequest<TotalGoal>
        do{
            let result = try ad.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty {
                guard let totalGoal = NSEntityDescription.insertNewObject(forEntityName: "TotalGoal", into: ad.persistentContainer.viewContext) as? TotalGoal else{return}
                totalGoal.step = 0
                ad.saveContext()
            }
            else{
                let totalGoal = result.first
                self.totalStep = totalGoal
             }
        }
        catch{
            print(error.localizedDescription)
        }

    }
    func getMonthEntity(){
        let todayBegin = NSCalendar.current.startOfDay(for: Date())
        let calendarComponent:Set<Calendar.Component> = [.year,.month]
        let monthComponent = Calendar.current.dateComponents(calendarComponent, from: todayBegin)
        guard let monthBegin = NSCalendar.current.date(from: monthComponent) else{return}
        let fetchRequest = Yearly.fetchRequest() as! NSFetchRequest<Yearly>
        let currentMonthPredicate = NSPredicate(format: "date == %@", monthBegin as NSDate)
        fetchRequest.predicate = currentMonthPredicate
        
        do {
            let result = try ad.persistentContainer.viewContext.fetch(fetchRequest)
            if result.isEmpty{
                currentMonthEntry = NSEntityDescription.insertNewObject(forEntityName: "Yearly", into: ad.persistentContainer.viewContext) as! Yearly
                currentMonthEntry?.date = monthBegin as NSDate
                ad.saveContext()
            }
            else{
                currentMonthEntry = result.first
            }
            
        } catch  {
            print(error.localizedDescription)
        }
        
        
        
    }
    func getWeeklyResult()->(data:[Double],label:[String]){
        let calendarComponent : Set<Calendar.Component> = [.year,.month,.weekOfMonth,.weekday]
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "E"
        
        var dateComponent = Calendar.current.dateComponents(calendarComponent, from: Date())
        var data = [Double]()
        var label = [String]()
        for weekday in 1...7{
            var dateToFetch = Date()
            dateComponent.weekday = weekday
            dateToFetch = Calendar.current.date(from: dateComponent)!
            let fetchRequest = DailyGoal.fetchRequest() as! NSFetchRequest<DailyGoal>
            let predicate = NSPredicate(format: "date == %@", dateToFetch as NSDate)
            fetchRequest.predicate = predicate
            do {
                let result = try ad.persistentContainer.viewContext.fetch(fetchRequest)
                if result.isEmpty{
                    data.append(Double(0))
                    label.append(dateFormat.string(from: dateToFetch))
                }
                else{
                    guard let res = result.first else {
                        return (data,label)
                    }
                    data.append(Double(res.actualStep))
                    label.append(dateFormat.string(from: dateToFetch))
                }
                
            } catch  {
                print(error.localizedDescription)
            }
        }
        return (data,label)
    }
    func getMonthlyResult() ->(data:[Double],label:[String]){
        let calendarComponent : Set<Calendar.Component> = [.year,.month]
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM"
        
        var dateComponent = Calendar.current.dateComponents(calendarComponent, from: Date())
        var data = [Double]()
        var label = [String]()
        for month in 1...12{
            var dateToFetch = Date()
            dateComponent.month = month
            dateToFetch = Calendar.current.date(from: dateComponent)!
            let fetchRequest = Yearly.fetchRequest() as! NSFetchRequest<Yearly>
            let predicate = NSPredicate(format: "date == %@", dateToFetch as NSDate)
            fetchRequest.predicate = predicate
            do {
                let result = try ad.persistentContainer.viewContext.fetch(fetchRequest)
                if result.isEmpty{
                    data.append(Double(0))
                    label.append(dateFormat.string(from: dateToFetch))
                }
                else{
                    guard let res = result.first else {
                        return (data,label)
                    }
                    data.append(Double(res.actualStep))
                    label.append(dateFormat.string(from: dateToFetch))
                }
                
            } catch  {
                print(error.localizedDescription)
            }
        }
        return (data,label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    //MARK: - BlT Delegate Method
    func didGetStep(_ step: String) {
        if let stepModel = NSEntityDescription.insertNewObject(forEntityName: "Step", into: (ad.persistentContainer.viewContext)) as? Step{
            stepModel.count = Int32(step) ?? 0
            stepModel.timestamp = Date()
            if let todaygoal = self.todayGoal{
                todaygoal.actualStep += stepModel.count
                if let monthEntry = self.currentMonthEntry{
                    monthEntry.actualStep += stepModel.count
                }
                let userStepRef = FirebaseManager.sharedInstance.userDatabaseRef.child((Auth.auth().currentUser?.uid)!).child("totalStep")
                let dailyStepRef = FirebaseManager.sharedInstance.stepStatisticRef.child((Auth.auth().currentUser?.uid)!).child((todayGoal?.date?.description)!)
                dailyStepRef.setValue(todayGoal?.actualStep)
                guard let totalStep = self.totalStep else { return  }
                totalStep.step = totalStep.step + Int32(step)!
                userStepRef.setValue(totalStep.step)
            }
           
            
            ad.saveContext()
        }
        print(step)
        
        
    }
    
    func didGetHeartRate(_ heartRate: String) {
        
    }
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

  

    func showWeeklyGraph(){
        let result = getWeeklyResult()
        graphView.set(result.data, withLabels: result.label)
    }
    func showMonthlyGraph(){
        let result = getMonthlyResult()
        graphView.set(result.data, withLabels: result.label)
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        bltManager?.getSteps()
        getTodaysGoal()
        updateRingprogress()
    }
   
    
    @IBAction func chooseGraphFilter(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showWeeklyGraph()
            print("selcted weekly")
        case 1:
            showMonthlyGraph()
            print("selected yearly")
        default: break
            
        }
    }
    @IBAction func shareAction(_ sender: UIButton) {
        shareScreenShotWithFb()
    }
    func renderImageFromMap(view:UIView, frame:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size,true,0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        view.draw(frame)
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderedImage
    }
    //MARK: - For testing uses
    func addDummyDataForTheCurrentMonth() {
        var currentDate = Date()
        currentDate = Calendar.current.startOfDay(for: currentDate)
        for x in 1...30 {
            //Initialize with random numbers
            let randomSteps = Int(arc4random_uniform(UInt32(10000)))
            print(x, randomSteps)
            
            let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: x, to: currentDate, options: [])!
            initializeDummyFitnessData(dateToAdd: calculatedDate)
        }
    }
    func initializeDummyFitnessData(dateToAdd: Date) {
        
        //Access managedObjectContex
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "DailyGoal", in: context)!
        let fitnessData = DailyGoal(entity: entity, insertInto: context)
        
        //Initialize with random numbers
        let randomSteps = Int(arc4random_uniform(UInt32(10000)))
        
        fitnessData.date = dateToAdd
        fitnessData.actualStep = Int32(randomSteps)
        
        
        //Add object to context
        context.insert(fitnessData)
        
        do {
            try context.save()
        } catch {
            print("Could not save fitness Data")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
