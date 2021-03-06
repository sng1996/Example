//
//  CalendarViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 27.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    //VIEW
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var myButton: UIButton!

    
    //CONTROLLER
    var order:Order!
    let formatter = DateFormatter()
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентбрь", "Октябрь", "Ноябрь", "Декабрь"]
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavbar()
        setupCalendarView()
        setupMyView()
        setupMyImageView()
        setupTimeView()
        setupMyButton()
        setupTimePicker()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        designNavbar()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = .black
            } else {
                validCell.dateLabel.textColor = UIColor(red: 158/255.0, green: 171/255.0, blue: 205/255.0, alpha: 0.5)
            }
        }
    }
    
    //ACTIONS
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(){
        
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from:calendarView.selectedDates.first!)
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from:timePicker.date)
        order.finishDate = dateString + " " + timeString
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CostViewController") as! CostViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    
    //DESIGN VIEW
    
    func designNavbar(){
        
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        self.navigationController?.navigationBar.layer.dropBottomBorder()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 17)!]
        self.navigationController?.navigationBar.layer.setBottomBorder()
        
    }
    
    func setupMyView(){
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.1
        myView.layer.shadowOffset = CGSize.zero
        myView.layer.shadowRadius = 5
        myView.layer.cornerRadius = 5
    }
    
    func setupMyImageView(){
        myImageView.layer.shadowColor = UIColor.black.cgColor
        myImageView.layer.shadowOpacity = 0.1
        myImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myImageView.layer.shadowRadius = 2
        myImageView.layer.cornerRadius = 5
    }
    
    func setupTimeView(){
        timeView.layer.cornerRadius = 17
        timeView.layer.shadowColor = UIColor.black.cgColor
        timeView.layer.shadowOpacity = 0.4
        timeView.layer.shadowOffset = CGSize(width: 0, height: 4)
        timeView.layer.shadowRadius = 3
    }
    
    func setupMyButton(){
        myButton.layer.cornerRadius = 20
    }
    
    func setupTimePicker(){
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func setupCalendarView(){
        calendarView.selectDates([Date()])
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates(){ (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MM"
        self.month.text = months[Int(self.formatter.string(from: date))! - 1]
        self.date = date
    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        let endDate = formatter.date(from: "2017 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate!,
                                                 numberOfRows: nil,
                                                 calendar: nil,
                                                 generateInDates: nil,
                                                 generateOutDates: nil,
                                                 firstDayOfWeek: .monday,
                                                 hasStrictBoundaries: nil)
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        if cellState.isSelected{
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true
        }
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else {return}
        validCell.selectedView.isHidden = false
        validCell.dateLabel.textColor = .white
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else {return}
        validCell.selectedView.isHidden = true
        validCell.dateLabel.textColor = .black
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
}
