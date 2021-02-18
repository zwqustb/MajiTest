//
//  MathTools.swift
//  biniu
//
//  Created by zhangwenqiang on 2018/5/4.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    mutating func roundValue()->Double{
        var nDimension = 6
        if abs(self)>=1{
            nDimension = 2
        }
        let divisor = pow(10.0, Double(nDimension))
        return (self * divisor).rounded() / divisor
    }
    mutating func cutValue()->Double{
        var nDimension = 6
        if abs(self)>=10{
            nDimension = 2
        }
        let divisor = pow(10.0, Double(nDimension))
        return (self * divisor).rounded() / divisor
    }
    func cutValue(_ nDimension:Int)->Double{
//        if abs(self)>=10{
//            nDimension = 2
//        }
        let divisor = pow(10.0, Double(nDimension))
        return (self * divisor).rounded() / divisor
    }
    //没有科学计数法的string
    func normalStringFrom() -> String
    {
        var stringValue = "0.00"
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true;
        formatter.maximumSignificantDigits = 100
        formatter.groupingSeparator = "";
        formatter.numberStyle = .decimal
        stringValue = formatter.string(from: NSNumber.init(value: self)) ?? "0.00"
        return stringValue
    }
    // MARK:- 转成 2位byte Uint16
    func to2Bytes(_ bigEndian:Bool) -> [UInt8] {
        let UInt = UInt16.init(Double.init(self))
        return bigEndian ? [UInt8(truncatingIfNeeded: UInt >> 8),
                            UInt8(truncatingIfNeeded: UInt)]:[UInt8(truncatingIfNeeded: UInt),
                                                              UInt8(truncatingIfNeeded: UInt >> 8)]
    }
    // MARK:- 转成 4字节的bytes Uint32
    func to4Bytes(_ bigEndian:Bool) -> [UInt8] {
        let UInt = UInt32.init(Double.init(self))
        return bigEndian ? [UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
        UInt8(truncatingIfNeeded: UInt)]:[UInt8(truncatingIfNeeded: UInt),
        UInt8(truncatingIfNeeded: UInt >> 8),
        UInt8(truncatingIfNeeded: UInt >> 16),
        UInt8(truncatingIfNeeded: UInt >> 24)]
    }
    // MARK:- 转成 8位 bytes
    func to8Bytes(_ bigEndian:Bool) -> [UInt8] {
        let UInt = UInt64.init(Double.init(self))
        return bigEndian ? [UInt8(truncatingIfNeeded: UInt >> 56),
                UInt8(truncatingIfNeeded: UInt >> 48),
                UInt8(truncatingIfNeeded: UInt >> 40),
                UInt8(truncatingIfNeeded: UInt >> 32),
                UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
        UInt8(truncatingIfNeeded: UInt)]:[UInt8(truncatingIfNeeded: UInt),
        UInt8(truncatingIfNeeded: UInt >> 8),
        UInt8(truncatingIfNeeded: UInt >> 16),
        UInt8(truncatingIfNeeded: UInt >> 24),
        UInt8(truncatingIfNeeded: UInt >> 32),
        UInt8(truncatingIfNeeded: UInt >> 40),
        UInt8(truncatingIfNeeded: UInt >> 48),
        UInt8(truncatingIfNeeded: UInt  >> 56)]
    }
}
extension CGFloat{
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (Double(self) * divisor).rounded() / divisor
    }
}
extension NSNumber{
    func roundDouble(_ nDimension:Int) -> Double{
        let pDouble = self.doubleValue
        return pDouble.rounded(toPlaces:1)
    }
}
extension Int{
    func toHourStr()->String{
        if self < 10 {
            return "0\(self)"
        }else{
            return "\(self)"
        }
    }
    func secToMS()->String{
        return DateTools.getMSFromS(seconds: self)
    }
}
