//
//  FirstViewController.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/7/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var QuestionLabel: UILabel!
    
    @IBOutlet weak var firstChoiceBtn: BaseBtn!

    @IBOutlet weak var secondChoiceBtn: BaseBtn!
    
    @IBOutlet weak var thirdChoiceBtn: BaseBtn!
 
    private let model = DatabaseManager.sharedModel
    
    private var recordsData = [QuestionClass]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        model.isFirstLaunched()
        
        model.resetQuestions()
        
        setUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        recordsData.removeAll()
        
    }
    
    private func setUI () {
        
        model.pickRandomQuestion()
        
        if let pickedQuestion = model.pickedQuestion {
            
            QuestionLabel.text = pickedQuestion.question
            
            switch model.mode {
            case "Binary":
                
                firstChoiceBtn.setTitle("Yes", forState: .Normal)
                secondChoiceBtn.setTitle("No", forState: .Normal)
                thirdChoiceBtn.hidden = true
                
            case "Multiple":
                
                if let choices = pickedQuestion.choices {
                    
                    firstChoiceBtn.setTitle(choices[0], forState: .Normal)
                    secondChoiceBtn.setTitle(choices[1], forState: .Normal)
                    thirdChoiceBtn.hidden = false
                    thirdChoiceBtn.setTitle(choices[2], forState: .Normal)
                    
                }

            default :
                break
            }
            
        } else {
            
            var message = ""
            
            for (index,singleRecord) in recordsData.enumerate() {
                message += "Question № \(index + 1) = \(singleRecord.flag)\n"
            }
            
            sendRecordsAllert("Records", message: message)
            
        }
    
    }
    
    @IBAction func possibleChoicePressed(sender: BaseBtn) {
        
        if let pickedQuestion = model.pickedQuestion {
            
            if pickedQuestion.answer == sender.currentTitle {
                
                pickedQuestion.flag = true
                
                recordsData.append(pickedQuestion)
                
                sendAllert("Correct!", message: "The right answer is : \(pickedQuestion.answer)")
                
            } else {
                
                pickedQuestion.flag = false
                
                recordsData.append(pickedQuestion)
                
                sendAllert("Sorry, you are wrong!", message: "The right answer is: \(pickedQuestion.answer)")
            }
     
        }
        
    }

    
    private func sendAllert (title : String , message : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { Void in
            self.setUI()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    private func sendRecordsAllert (title : String , message : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.Default,handler: { Void in
            
            self.model.resetQuestions()
            
            self.recordsData.removeAll()
            
            self.setUI()
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }


}

