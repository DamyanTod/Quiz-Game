//
//  Question.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/7/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//

import Foundation

class QuestionClass {
    
    let question:String
    let answer:String
    var choices:[String]?
    var flag = false
    
    init (question : String , answer : String , choices : [String]?) {
        self.question = question
        self.answer = answer
        self.choices = choices
    }
    
}