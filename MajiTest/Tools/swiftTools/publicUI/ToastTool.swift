//
//  ToastTool.swift
//  ZwqLife
//
//  Created by boeDev on 2020/6/5.
//  Copyright © 2020 zwq. All rights reserved.
//

import UIKit
func toast(_ strText:String){
    ToastTool.shareInstence.showText(strText)
}
class ToastTool: UIView {
    static let shareInstence = ToastTool()
    weak var m_pLabel:UILabel?
    func showText(_ strContent:String){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(removeLastLabel), object: nil)
        let pLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth-100, height: 100))
        pLabel.text = strContent
        self.perform(#selector(removeLastLabel(_:)), with: pLabel, afterDelay: 3)
        UIApplication.shared.windows.first?.addSubview(pLabel)
    }
    @objc func removeLastLabel(_ pLabel:UILabel){
        pLabel.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
