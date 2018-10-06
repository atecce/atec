//
//  Hit.swift
//  atec
//
//  Created by Alex Tecce on 10/6/18.
//  Copyright © 2018 telos. All rights reserved.
//

import CloudKit

struct Hit {
    let recordID: CKRecord.ID
    
    var method = ""
    var path = ""
    var remoteAddr = ""
    var host = ""
    
    init(record: CKRecord) {
        self.recordID = record.recordID
        
        if let method = record["method"] as? String {
            self.method = method
        }
        
        if let path = record["path"] as? String {
            self.path = path
        }
        
        if let remoteAddr = record["remoteAddr"] as? String {
            self.remoteAddr = remoteAddr
        }
        
        if let host = record["host"] as? String {
            self.host = host
        }
    }
}
