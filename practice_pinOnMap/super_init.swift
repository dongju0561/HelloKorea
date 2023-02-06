//
//  super_init.swift
//  practice_pinOnMap
//
//  Created by Dongju Park on 2023/02/06.
//

import Foundation
class parent {
    var num = 1
    var num2 = 1
    
    init(num: Int = 1, num2: Int = 1) {
        self.num = num
        self.num2 = num2
    }
}

class child: parent {
    var cnum = 0
    init(cnum: Int = 0) {
        super.init(num: 3, num2: 1)
        self.cnum = cnum
    }
}

var childv = child(cnum: 1)
func test() {
    print(childv.num)
    print(childv.num2)
    print(childv.cnum)
}

