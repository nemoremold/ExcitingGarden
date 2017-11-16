//
//  Manager.swift
//  Excited
//
//  Created by Emoin Lam on 15/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

let DEFAULT_INCREMENT = 1

/*
 ListManager Functionalities
    - helps managing an array by using the technique of linked list
    - initialized with (DEFAULT_STARTER, DEFAULT_END)
 
 ListMangaer Methods
    - getNextIndex() returns with an Integer, indicating the best place to insert into an array
    - deleteIndex(index: Int) returns with a ListManager object used to modify the current ListManager, indicating that array index marked as (index) is added to the linked list for adding new element
*/
class ListManager {
    var _next: ListManager?
    var _ID: Int
    var _end: Int
    init(id: Int, end: Int) {
        self._ID = id
        self._end = end
    }
    
    // MARK: Methods
    func getNextIndex() -> Int {
        var ret: Int
        ret = _ID
        
        if _next == nil {
            self._ID = self._end
            self._end += DEFAULT_INCREMENT
        }
        else {
            self._ID = (_next?._ID)!
            self._end = (_next?._end)!
            _next = _next?._next
        }
        
        return ret
    }
    
    func deleteIndex(index: Int) -> ListManager {
        let new = ListManager(id: index, end: _end)
        new._next = self
        return new
    }
}
