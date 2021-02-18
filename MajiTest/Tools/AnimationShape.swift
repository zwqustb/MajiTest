//
//  AnimationShape.swift
//  ZwqLife
//
//  Created by boeDev on 2020/6/1.
//  Copyright © 2020 zwq. All rights reserved.
//

import SwiftUI

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    var animatableData: Angle {
        get { endAngle }
        set { self.endAngle = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}
class LifeRange:ObservableObject{
    @Published var dSelectLife = 0.0
    @Published var dMaxLife = 180.0
    @Published var dUserLife = 0.0
}
struct LifeArc: View {
    @ObservedObject var pLifeRange = LifeRange()
    var animatableData: LifeRange {
          get { pLifeRange }
          set { self.pLifeRange = newValue }
      }
    var body: some View {
        ZStack{
            //底部灰色
            Arc.init(startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
                .stroke(Color.gray,style: StrokeStyle.init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .pi))
                .frame(width: 200, height: 200, alignment: .bottomLeading)
            //中间红色
            Arc.init(startAngle: .degrees(0), endAngle: .degrees(pLifeRange.dSelectLife*360/pLifeRange.dMaxLife), clockwise: true)
                .stroke(Color.red,style: StrokeStyle.init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .pi))
                .frame(width: 200, height: 200, alignment: .bottomLeading)
                .padding(10)
            //中间绿色
            if pLifeRange.dUserLife <= pLifeRange.dSelectLife {
                Arc.init(startAngle: .degrees(0), endAngle: .degrees(pLifeRange.dUserLife*360/pLifeRange.dMaxLife), clockwise: true)
                    .stroke(Color.green,style: StrokeStyle.init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .pi))
                    .frame(width: 200, height: 200, alignment: .bottomLeading)
                    .padding(10)
            }
            //上层蓝色 发育期 = 理论寿命/15
            Arc.init(startAngle: .degrees(0), endAngle: .degrees(pLifeRange.dSelectLife*360/pLifeRange.dMaxLife/15), clockwise: true)
                .stroke(Color.blue,style: StrokeStyle.init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: .pi))
                .frame(width: 200, height: 200, alignment: .bottomLeading)
                .padding(10)
            
        }
    }
}
