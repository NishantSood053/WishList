//
//  ItemDetailsVC.swift
//  WishList
//
//  Created by Nishant Sood on 2/19/17.
//  Copyright © 2017 Nishant Sood. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores  = [Store]()
    
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem{
        
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //generateStores()
        
        appDelegate.saveContext()
        
        getStores()
        
        if itemToEdit != nil{
            loadItemData()
        }
        
        //Dismiss keyboard functionality
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    //How many columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Update when selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores()
    {
    
        let fetchRequest: NSFetchRequest<Store>  = Store.fetchRequest()
        
        do{
        
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        }catch {
        
            print("Could not fetch")
            
        }
    }
    
    func generateStores()
    {
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context: context)
        store3.name = "Walmart"
        let store4 = Store(context: context)
        store4.name = "K Mart"
        let store5 = Store(context: context)
        store5.name = "Food Basics"
        let store6 = Store(context: context)
        store6.name = "Dollar Tree"

    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        
        //Check if we are updating the existing item or adding a new one
        if itemToEdit == nil{
        
            item  = Item(context: context)
            
        }else{
        
            item = itemToEdit
        }
        
        if let title = titleField.text{
        
            item.title = title
        }
        
        if let price = priceField.text{
            
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            
            item.details = details
        }
        
        //inComponent is the column
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    func loadItemData(){
    
        if let item = itemToEdit{
        
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            if let store = item.toStore{
            
                var index = 0
                
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name{
                    
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        break
                    }
                
                    index += 1
                    
                }while(index < stores.count)
            }
        }
        
    }

    
    
}












