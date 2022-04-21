//
//  TaskModel.swift
//  TaskManagement
//
//  Created by Rendi Wijiatmoko on 21/04/22.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var date: Date
}
