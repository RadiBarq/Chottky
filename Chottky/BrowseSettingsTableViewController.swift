//
//  BrowseSettingsTableViewController.swift
//  Chottky
//
//  Created by Radi Barq on 9/1/17.
//  Copyright © 2017 Chottky. All rights reserved.
//

import UIKit

class BrowseSettingsTableViewController: UITableViewController {

    @IBOutlet var resetButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    
    let sectionHeaderTitleArray = ["التصنيفات", "تم نشر المنتج من مدة", "المسافة", "الترتيب حسب"]
    let categoriesArray = ["سيارات","الكترونيات","شقق و اراضي","البيت و الحديقة","حيوانات","الرياضة و الالعاب","ملابس و اكسسوارات","الاطفال","افلام، كتب و اغاني","اغراض اخرى"]
    let postedWithinArray = ["اخر ٢٤ سيعة", "اخر ٧ ايام", "في اخر ٣٠ يوم", "كل المنتجات"]
    let distanceArray = ["قريب جدا (١ كم)", "في الاحياء القريبة (٥كم)", "في مدينيتي (١٠كم)", "في مدينيتي (١٠كم)", "لم يحدد"]
    let sortedByArray = ["الاقرب اولا", "السعر من الاعلى الى الاقل", "السعر من الاقل  الى الاعلى", "الاجدد اولا"]
    
    var selectedCategoriesIndexes: Array? = []
    var selectedPostedWithInIndex: Int?
    var selectedDistanceIndex: Int?
    var selectedsortedByIndex: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.topItem?.title = "اعدادات التصفح"
        self.navigationController?.navigationBar.isTranslucent = false
        
       // self.tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaderTitleArray[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 30, width: view.frame.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: -10, y: 22, width: view.frame.size.width, height: 10))
        
        label.text = self.sectionHeaderTitleArray[section]
        label.textColor = Constants.FirstColor

        label.textAlignment = .right
        returnedView.addSubview(label)
        return returnedView
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
        
        if indexPath.section == 0
        {
            selectedCell.removeImageView()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section // this is the section number.
        let row = indexPath.row  // this is the row number.
        let selectedCell =  tableView.cellForRow(at: indexPath) as! BrowseSettingsTableViewCell
        
        if (section == 0)
        {
            
            let sectionNumber = 0
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            selectRowsInSection(rowsCount:  numberOfRowsInSection, section: sectionNumber)
            
        }
        

        else if (section == 1)
        {
            
            let sectionNumber = 1
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            unselectRowsInSection(rowsCount: numberOfRowsInSection, section: sectionNumber)
            selectedCell.addImageView()
            selectedPostedWithInIndex = row
    
        }
        
        else if (section == 2)
        {
            
            let sectionNumber = 2
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            unselectRowsInSection(rowsCount: numberOfRowsInSection, section: sectionNumber)
            selectedCell.addImageView()
            selectedDistanceIndex = row
        }
        
        else
        {

            let sectionNumber = 3
            let numberOfRowsInSection = tableView.numberOfRows(inSection: sectionNumber)
            unselectRowsInSection(rowsCount: numberOfRowsInSection, section: sectionNumber)
            selectedCell.addImageView()
            selectedsortedByIndex = row
            
        }
    }
    
    func unselectRowsInSection(rowsCount: Int, section: Int)
    {
        
        for row in 0 ..< rowsCount
        {
            var indexPath  = NSIndexPath(row: row, section: section)
            var cell = tableView.cellForRow(at: indexPath as IndexPath) as? BrowseSettingsTableViewCell
            
            if (cell != nil)
            {
                
                cell?.setSelected(false, animated: true)
                cell?.removeImageView()
            }
           
        }
    }
    
    func selectRowsInSection(rowsCount: Int, section: Int)
    {
        
        for row in 0 ..< rowsCount
        {
            
            var indexPath  = NSIndexPath(row: row, section: section)
            var cell = tableView.cellForRow(at: indexPath as IndexPath) as! BrowseSettingsTableViewCell
            
            if cell.isSelected == true
            {
                
                cell.addImageView()
            }
                
            else
            {
                cell.removeImageView()

            }
        }
    }
}
