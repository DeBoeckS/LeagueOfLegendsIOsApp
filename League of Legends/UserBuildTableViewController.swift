//
//  UserBuildTableViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 15/01/16.
//  Copyright © 2016 Simon De Boeck. All rights reserved.
//

import UIKit
import CoreData

class UserTableViewController: UITableViewController{
    
    var builds: [NSManagedObject] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let fetchRequest = NSFetchRequest(entityName: "UserBuild")
        
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            builds = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buildCell", forIndexPath: indexPath)
        let build = builds[indexPath.item]
        cell.textLabel!.text = build.valueForKey("name") as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if let cntr = segue.destinationViewController as? StartViewController{
            
        }else{
        if let detailController = (segue.destinationViewController as? UINavigationController)!.topViewController as? UserBuildDetailUICollectionViewController{
        let build = builds[tableView.indexPathForSelectedRow!.row]
        detailController.userBuild = build

      
            
        }
            
        }

        
    }

    
    @IBAction func goBackToUserTableViewController(segue: UIStoryboardSegue){
        
        switch(segue.identifier!){
            case "deleteBuild":
                
            let detailController = segue.sourceViewController as! UserBuildDetailUICollectionViewController
            let deletedBuild = detailController.userBuild
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(deletedBuild)
            do{
            try managedContext.save()
                
            }catch let _ as NSError{
               
                return
            }
            
            
            default:
                return
        }
        
    }
    
    @IBAction func unwindFromUserBuildUICollectionView(segue: UIStoryboardSegue){
        let userBuildUICollectioncontroller = segue.sourceViewController as! UserBuildCollectionViewController
        
        let items = userBuildUICollectioncontroller.selecteditems
        
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entityForName("UserBuild",
            inManagedObjectContext:managedContext)
        
        let build = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        
        build.setValue("Build " + String(builds.count), forKey: "name")
        let savedItems = build.mutableSetValueForKey("items")
        for item in items{
            savedItems.addObject(item)
        }
      
        
        
        
        do {
            try managedContext.save()
            
            builds.append(build)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
      
        
        self.tableView.reloadData()
        
        
    }
}
