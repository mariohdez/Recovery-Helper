//
//  CalendarViewController.swift
//  Recovery Helper
//
//  Created by Mario Hernandez on 4/30/17.
//  Copyright © 2017 Mario Hernandez. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor(hexString: "0X584A66")
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(hexString: "0X3A294B")
    let currentDateSelectedView = UIColor(hexString: "0X4E3F5D")
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        setUpNavigationBar()
        
        
    }
    func setUpNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.init(r: 81, g: 51, b: 93)
        //        navigationController?.navigationBar.isTranslucent = false
        email =  parseForEmailHanlder(email: fetchCurUserName())
        print(email)
        self.title = email
        navigationItem.title = email
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
        
        
        
    }
    
    func handleLogout() {
        do{
            try FIRAuth.auth()?.signOut()
            print("User is logged out!")
        } catch let signOutError {
            print(signOutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    func setupCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        let visibleDates = calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
        
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let currCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            currCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                currCell.dateLabel.textColor = monthColor
            } else {
                currCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func fetchCurUserName () ->String? {
        if let user = FIRAuth.auth()?.currentUser {
            return parseForEmailHanlder(email: user.email);
        }
        else{
            return nil;
        }
    }
}


extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var startDate = formatter.date(from: "2017 05 01")!
        var endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters   
    }
}


extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    // Display the cell.
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        let dateView:DateViewController = DateViewController()
        dateView.date = date
        dateView.name = self.email
        let navigationController = UINavigationController(rootViewController: dateView)
        self.present(navigationController, animated: false, completion: nil)
    }

    /*func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
     
         handleCellSelected(view: cell, cellState: cellState) 
         handleCellTextColor(view: cell, cellState: cellState)
 
    } */
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
        
    }
    
}


/*
 let storyboard = UIStoryboard(name: "calendar", bundle: nil)
 let vc = storyboard.instantiateViewController(withIdentifier: "calendar")
 let navigationController = UINavigationController(rootViewController: vc)
 present(navigationController, animated: false, completion: nil)
 */
