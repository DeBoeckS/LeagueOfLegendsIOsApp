//
//  StartViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//


import UIKit

class StartViewController: UIViewController{
    
    @IBAction func goToChampions(){
        performSegueWithIdentifier("goToChampions", sender: self)
    }
    
   
    
    @IBAction func goBackToStartViewController(segue: UIStoryboardSegue){
        
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
    
}
