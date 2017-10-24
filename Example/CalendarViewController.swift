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
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    var date: Date!

    var order:Order!
    let formatter = DateFormatter()
    let months: [String] = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентбрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.selectDates([Date()])
        setupCalendarView()
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.1
        myView.layer.shadowOffset = CGSize.zero
        myView.layer.shadowRadius = 5
        myView.layer.cornerRadius = 5
        myImageView.layer.shadowColor = UIColor.black.cgColor
        myImageView.layer.shadowOpacity = 0.1
        myImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myImageView.layer.shadowRadius = 2
        myImageView.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!]
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!]
    }
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates(){ (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MM"
        self.month.text = months[Int(self.formatter.string(from: date))! - 1]
        self.date = date
    }

    func nextView(){
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from:calendarView.selectedDates.first!)
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from:timePicker.date)
        print(dateString + " " + timeString)
        order.finishDate = dateString + " " + timeString
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = .black
            } else {
                validCell.dateLabel.textColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
            }
        }
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(){
        
        order.finishDate = formatter.string(from: Date())
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CostViewController") as! CostViewController
        nextViewController.order = order
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
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
