//
//  data.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import Foundation


class List{
    var listID: String?
    var listTitle: String?
    var listTime: String?
    var listNotes: String?
    var listDone: Bool?
    
    init(){}
    
    init(listID: String? = nil, listTitle: String? = nil, listTime: String? = nil, listNotes: String? = nil , listDone: Bool? = nil) {
        self.listID = listID
        self.listTitle = listTitle
        self.listTime = listTime
        self.listNotes = listNotes
        self.listDone = listDone
    }
}
