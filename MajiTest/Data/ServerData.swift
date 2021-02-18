//
//  ServerData.swift
//  MajiTest
//
//  Created by 张文强 on 2021/2/17.
//

import Foundation
class CurServerData: NSObject {
    static var shared = CurServerData()
    var dicData:[String:String] = [:]
    var curDataDate:Date?
}
