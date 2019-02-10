//
//  TimeBusinessModel.swift
//  TakeHomeTest
//
//  Created by Abbas on 2/10/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

class TimeBusinessModel :Codable{
    var datetime: String = ""
    
    convenience init?(datetime : String) {
        self.init()
        self.datetime = datetime
    }
    
    func getTime() -> String?{
        if let partition = self.datetime.split(separator: " ").last {
            if let time = partition.split(separator: ".").first {
                return String(time)
            }
        }
        return nil
    }
}
