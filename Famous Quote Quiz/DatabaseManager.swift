//
//  DatabaseManager.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/7/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {

    static let sharedModel = DatabaseManager()
    
    var questions = [QuestionClass]()
    
    var pickedQuestion:QuestionClass?
    
    var mode = "Binary"
    
    private var allQuestions = [String:NSArray]()
    
    private let dbContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var numberForSession = 0
 
    private init(){}
    
    func isFirstLaunched() {

        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if !userDefault.boolForKey("hasLaunchedOnce") {
            
            parsePlists()
            questions = getModes()
    
            userDefault.setBool(true, forKey: "hasLaunchedOnce")
            userDefault.synchronize()
            
        }
    }
    
    private func setAllQuestions() -> [String:NSArray] {
        
        var result = [String:NSArray]()
        
        if let path = NSBundle.mainBundle().pathForResource("Binary", ofType: "plist") {
            if let binary = NSArray(contentsOfFile: path) as? [Dictionary<String, AnyObject>] {
                result["Binary"] = binary
            }
        }
        
        if let path = NSBundle.mainBundle().pathForResource("Multiple", ofType: "plist") {
            if let multiple = NSArray(contentsOfFile: path) as? [Dictionary<String, AnyObject>] {
                result["Multiple"] = multiple
            }
        }
        
        return result
    }

    
    private func parsePlists() {
        
        allQuestions = setAllQuestions()
        
        for (mode,questions) in allQuestions {
            
            //MARK Mode
            if let modeObj:Mode = NSEntityDescription.insertNewObjectForEntityForName("Mode", inManagedObjectContext: dbContext) as? Mode {
                
                modeObj.name = mode
                
                for question in questions {
                    
                    //MARK Question
                    if let questionInfo = question["Question"] as? String ,
                        let answer = question["Answer"] as? String ,
                        let modelQuestion = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: dbContext) as? Question {
                            
                            modelQuestion.question = questionInfo
                            modelQuestion.answer = answer
                            modelQuestion.mode = modeObj
                            
                            //MARK Choice
                            if let choiceArray = question["Choice"] as? [String] {
                                
                                for choice in choiceArray {
                                    
                                    if let modelChoice = NSEntityDescription.insertNewObjectForEntityForName("Choice", inManagedObjectContext: dbContext) as? Choice {
                                        
                                        modelChoice.question = modelQuestion
                                        modelChoice.choice = choice
                                        
                                    }
                                }
                            }
                    }
                }
            }
        }
        do {
            try dbContext.save()
        } catch {
            print("DatabaseManager error :\(error)")
        }

    }

    func pickRandomQuestion () {
        
        numberForSession += 1
        
        if numberForSession < 11 {
            
            let randomQuestionNumber = random() % questions.count
            
            pickedQuestion = questions[randomQuestionNumber]

            questions.removeAtIndex(randomQuestionNumber)
            
        } else {
            pickedQuestion = nil
        }

    }
    
    func resetQuestions () {
        
        numberForSession = 0
    
        questions.removeAll()
        
        questions = getModes()

    }
 
}

//Get Mode
extension DatabaseManager {
    
    func getModes() -> [QuestionClass] {
        
        return self.fetchRecordsFromEntity("Mode", possibleMode : mode)
        
    }
    
    private func fetchRecordsFromEntity(entityName: String , possibleMode : String) -> [QuestionClass] {
        
        var objects = [QuestionClass]()
        
        let request: NSFetchRequest = NSFetchRequest()
        
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: dbContext)
        
        request.predicate = NSPredicate(format: "name = %@", possibleMode)
        
        do {
            if let result = try dbContext.executeFetchRequest(request) as? [Mode] {
                
                objects = convertQuestionArray(result)
            }
            
        } catch {
            print("DatabaseManager error :\(error)")
        }
        
        return objects
    }
    
    
    private func convertQuestionArray (entityArray : [Mode]) -> [QuestionClass] {
        
        var result = [QuestionClass]()
        
        for singleMode in entityArray {
            
            if let questions = singleMode.questions?.allObjects as? [Question] {
                
                for singleQuestion in questions {
                    
                    if let question = singleQuestion.question ,
                        let answer = singleQuestion.answer {
                        
                            let questionClass = QuestionClass( question: question, answer: answer, choices: self.getChoiceAnswers((singleQuestion.choices?.allObjects)))
                            
                            result.append(questionClass)
                            
                    }
                }
            }
        }
        return result
    }
    
    private func getChoiceAnswers (choiceArray : [AnyObject]?) -> [String] {
        
        var choiceResult = [String]()
        
        if let choiceArr = choiceArray as? [Choice] {
            for ch in choiceArr {
                if let choice = ch.choice {
                    
                    choiceResult.append(choice)
                    
                }
            }
        }
        return choiceResult
    }
}