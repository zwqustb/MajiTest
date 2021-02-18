//
//  MathTools.swift
//  ZwqLife
//
//  Created by boeDev on 2020/6/1.
//  Copyright © 2020 zwq. All rights reserved.
//

import UIKit

class MathTools: NSObject {
    //正右侧为0点
    class func angleBetweenPoints(center:CGPoint,touch:CGPoint)->CGFloat{
        let width = touch.x - center.x
        //IOS的y轴坐标是从下到上递增
        let height =  center.y - touch.y
        let rads = atan(height/width)
        return radiansToDegrees(rads)
    }
    class func radiansToDegrees(_ radians:CGFloat)->CGFloat{
        return radians*180/CGFloat(Double.pi)
    }
    //正上方为0点
    class func angleTop0BetweenPoints(center:CGPoint,touch:CGPoint)->CGFloat{
        var degreeRet:CGFloat = 0
        let width = touch.x - center.x
        //IOS的y轴坐标是从下到上递增
        let height =  center.y - touch.y
        let rads = atan(abs(height/width))
        let degree = radiansToDegrees(rads)
        if width>0 && height>0 {
            //象限1
            degreeRet = 90 - degree
        }else if width>0{
            //象限2
            degreeRet = 90 + degree
        }else if width<0 && height<0 {
            //象限3
            degreeRet = 270 - degree
        }else if width<0{
            //象限4
            degreeRet = 270 + degree
        }
        return degreeRet
    }
}
