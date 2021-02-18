//
//  WifiTools.swift
//  MobileHealth
//
//  Created by boeDev on 2018/11/23.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration
func showInfo(_ strInfo:String)  {
    print(strInfo)
}
class WifiTools: NSObject,CLLocationManagerDelegate {
    static let shareInstence = WifiTools.init()
    var locationManager = CLLocationManager()
    weak var m_pWifiNameLabel:UITextField?
    class func getMAC()->(success:Bool,ssid:String,mac:String){
        shareInstence.locationManager.delegate = shareInstence
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
           // Request when-in-use authorization initially
           shareInstence.locationManager.requestWhenInUseAuthorization()
           break
              
        case .restricted, .denied:
           // Disable location features
           showInfo("请开启GPS定位!")
           break
              
        case .authorizedWhenInUse, .authorizedAlways:
           // Enable location features
//             if let cfa:NSArray = CNCopySupportedInterfaces() {
//                     for x in cfa {
//                         if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
//                             let ssid = dict["SSID"]!
//                             let mac  = dict["BSSID"]!
//                             return (true,ssid as! String,mac as! String)
//                         }
//                     }
//                 }
           break
        }
      
        //BOEProgressHUD.showError(withStatus: "获取wifi信息失败")
        return (false,"","")
    }
    func locationManager(_ manager: CLLocationManager,
                          didChangeAuthorization status: CLAuthorizationStatus) {
       switch status {
          case .restricted, .denied:
                m_pWifiNameLabel?.placeholder = "开启APP定位权限,才能获取手机的wifi名称"
                m_pWifiNameLabel?.isEnabled = true
             break
          case .authorizedWhenInUse, .authorizedAlways:
            m_pWifiNameLabel?.text = WifiTools.getMAC().ssid
             break
          case .notDetermined:
             break
       }
    }
}
