//
//  ViewController.swift
//  MajiTest
//
//  Created by 张文强 on 2021/2/15.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    let strUrl = "https://api.github.com/"
    var aryKeys:Array<String> = []
    var aryValues:Array<String> = []
    var tableView = UITableView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.frame

        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        // Do any additional setup after loading the view.
        self.getServerData()
        weak var weakSelf = self
        self.dispatchTimer(timeInterval: 5, handler: { (pTimer) in
            weakSelf?.getServerData()
        }, needRepeat: true)
    }

    func getServerData(){
        weak var weakSelf = self
        HttpTools.get(strUrl, ["":""]) { (bRet, dicRet) in
            weakSelf?.aryKeys = dicRet.allKeys as? [String] ?? []
            weakSelf?.aryValues = dicRet.allValues as? [String] ?? []
            weakSelf?.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = aryKeys[indexPath.row]
        cell?.detailTextLabel?.text = aryValues[indexPath.row]
        
        return cell!
    }
    /// GCD实现定时器
       ///
       /// - Parameters:
       ///   - timeInterval: 间隔时间
       ///   - handler: 事件
       ///   - needRepeat: 是否重复
       func dispatchTimer(timeInterval: Double, handler: @escaping (DispatchSourceTimer?) -> Void, needRepeat: Bool) {
           
           let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
           timer.schedule(deadline: .now(), repeating: timeInterval)
           timer.setEventHandler {
               DispatchQueue.main.async {
                   if needRepeat {
                       handler(timer)
                   } else {
                       timer.cancel()
                       handler(nil)
                   }
               }
           }
           timer.resume()
           
       }
}

