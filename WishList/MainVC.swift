//
//  MainVC.swift
//  WishList
//
//  Created by Nishant Sood on 2/19/17.
//  Copyright © 2017 Nishant Sood. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Add the protocol
        tableView.dataSource = self
        tableView.delegate = self
        
        //generateTestData()
        
        attemptFetch()
        
        /*
        //Storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context)
        
        
        newItem.setValue(NSDate(), forKey: "created")
         */
    }

    //returns the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
        
        return UITableViewCell()
    }
    
    
    // returns the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections{
        
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    
    // returns the number of columns
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections{
        
                return sections.count
        }
        
        return 0
    }
    
    //returns the height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //Method to update the cell(row) info
    func configureCell(cell:  ItemCell, indexPath: NSIndexPath){
        
        //update cell
        
        let item  = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
        
    }
    
    //Fetch the data from the controller
    func attemptFetch(){
    
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self // Will let the corresponding methods to listen
        
        self.controller = controller
        
        do{
        
            try controller.performFetch()
            
            
        }catch{
                let error =  error as NSError
                print("\(error)")
            
        }
        
    }
    
    //Will listen to changes in table view
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    //Will be called when the data is changed in the table view
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    
    }
    
    //This method is used to insert,delete,update or move the data (Will be called when thd data fetch is perfomed)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case.insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        case.delete:
            if let indexPath = indexPath{
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        
        case.update:
            if let indexPath = indexPath{
                
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                //Update the cell data
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
            }
            break
        
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
            
        
        }
        
    }
    
    //Dummy method to generate test data
    func generateTestData(){
    
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 2400
        item.details = "I can't wait until the september event. I hope they release new Macbook Pro"
        
        let item2 = Item(context: context)
        item2.title = "Country Side House"
        item2.price = 279000
        item2.details = "My Dream Home"
        
        let item3 = Item(context: context)
        item3.title = "Ford Mustang"
        item3.price = 30000
        item3.details = "My Dream Car"
        
        appDelegate.saveContext()
        
    }
    

}

