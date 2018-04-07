//
//  NewCategoryViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/2/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var mainTBC = MainTabBarController()
    var selectedIcon = 0
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var categoryTypeSegControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectedIconImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func showParentScene(sender: AnyObject) {
        if sender === saveButton {
            
            if nameTextField.text == "" {
                let alertController = UIAlertController(title: "Unable to Save", message: "The Name field must be completed before saving.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            if mainTBC.isNewCategory {
                FinanceDB.instance.addCategory(nameTextField.text!, type: categoryTypeSegControl.selectedSegmentIndex, icon: selectedIcon)
            }
            else {
                FinanceDB.instance.updateCategory(mainTBC.categories[mainTBC.categoryToEditIndex.section][mainTBC.categoryToEditIndex.row].categoryID!, newName: nameTextField.text!, newIcon: selectedIcon, newType: categoryTypeSegControl.selectedSegmentIndex)
            }
            mainTBC.categories[0] = FinanceDB.instance.getCategories(0)
            mainTBC.categories[1] = FinanceDB.instance.getCategories(1)
            dismissViewControllerAnimated(true, completion: nil)
        }
        else if sender === cancelButton {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else if sender === deleteButton {
            
            if mainTBC.categories[0].count == 1 || mainTBC.categories[1].count == 1 {
                let alertController = UIAlertController(title: "Unable to Delete", message: "You must have at least one category in both the income and expense sections.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            // if the category has transactions associated with it, don't allow delete
            if FinanceDB.instance.categoryHasTransactions(mainTBC.categories[mainTBC.categoryToEditIndex.section][mainTBC.categoryToEditIndex.row].categoryID!) {
                // create the alert window
                let alertController = UIAlertController(title: "Unable to Delete Category", message: "This category is associated with past transactions and cannot be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                // create the alert window
                let alertController = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category?", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create buttons
                let nowAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                    {(alertAction: UIAlertAction!) in FinanceDB.instance.deleteCategory(self.mainTBC.categories[self.mainTBC.categoryToEditIndex.section][self.mainTBC.categoryToEditIndex.row].categoryID!); self.mainTBC.categories[0] = FinanceDB.instance.getCategories(0); self.mainTBC.categories[1] = FinanceDB.instance.getCategories(1); self.dismissViewControllerAnimated(true, completion: nil)})
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                
                alertController.addAction(nowAction)
                alertController.addAction(cancelAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        nameTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTBC = presentingViewController as! MainTabBarController
        
        if mainTBC.isNewCategory {
            selectedIcon = Int(arc4random_uniform(UInt32(mainTBC.categoryIcons.count)))
            deleteButton.hidden = true
            navBar.title = "New Category"
        }
        else {
            selectedIcon = mainTBC.categories[mainTBC.categoryToEditIndex.section][mainTBC.categoryToEditIndex.row].categoryIcon
            nameTextField.text = mainTBC.categories[mainTBC.categoryToEditIndex.section][mainTBC.categoryToEditIndex.row].categoryName
            deleteButton.hidden = false
            navBar.title = "Edit Category"
        }
        categoryTypeSegControl.selectedSegmentIndex = mainTBC.categoryType
        selectedIconImageView.image = mainTBC.categoryIcons[selectedIcon]
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainTBC.categoryIcons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iconCell", forIndexPath: indexPath)
        
        // next 3 lines copied from http://stackoverflow.com/questions/32921666/how-to-add-a-background-image-to-a-uicollectionviewcell-in-swift and modified
        
        let view=UIView()
        view.backgroundColor=UIColor(patternImage: mainTBC.categoryIcons[indexPath.row])
        cell.backgroundView=view
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIconImageView.image = mainTBC.categoryIcons[indexPath.row]
        selectedIcon = indexPath.row
    }
}
