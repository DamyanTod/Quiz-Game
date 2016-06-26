//
//  Mode+CoreDataProperties.swift
//  Famous Quote Quiz
//
//  Created by admin on 12/8/15.
//  Copyright © 2015 Oraganization. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mode {

    @NSManaged var name: String?
    @NSManaged var questions: NSSet?

}
