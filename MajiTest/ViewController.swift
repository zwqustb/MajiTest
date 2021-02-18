//
//  ViewController.swift
//  MajiTest
//
//  Created by 张文强 on 2021/2/15.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let strUrl = "https://api.github.com/"
    var aryKeys:Array<String> = []
    var aryValues:Array<String> = []
    var tableView = UITableView.init()
    var mycontext : NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
                mycontext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
            } else {
                print("IOS9");
                mycontext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            }
        
        tableView.frame = self.view.frame

        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        // Do any additional setup after loading the view.
        self.getLatestCoreData()
        self.getServerData()
        weak var weakSelf = self
        self.dispatchTimer(timeInterval: 5, handler: { (pTimer) in
            weakSelf?.getServerData()
        }, needRepeat: true)
    }

    func getServerData(){
        weak var weakSelf = self
        HttpTools.get(strUrl, ["":""]) { (bRet, dicRet) in
            if dicRet.isEqual(to: CurServerData.shared.dicData){
                weakSelf?.SavaDataToCoredata(nil)
            }else{
                CurServerData.shared.dicData = dicRet as! [String : String]
                CurServerData.shared.curDataDate = Date.init()
                weakSelf?.setUIData(dicRet)
            }
        }
    }
    func setUIData(_ dicRet:NSDictionary)  {
        self.aryKeys = dicRet.allKeys as? [String] ?? []
        self.aryValues = dicRet.allValues as? [String] ?? []
        self.SavaDataToCoredata(dicRet)
        self.aryKeys.insert("查看历史", at: 0)
        self.aryValues.insert("显示请求的历史", at: 0)
        self.tableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            let pVC = ShowViewController.init()
            showView(pVC)
        }
    }
    /// GCD实现定时器
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
    //core data 相关内容
    //保存数据到CoreData
    func SavaDataToCoredata(_ dicData:NSDictionary?){
        //先查,如果查到了,就不插入了
        let currentDate = Date.init()
        let rels = getResultByDate(currentDate)
        if rels != nil && rels!.count > 0  {
            return
        }
        //开始插入
        do{
            let inserInfo = NSEntityDescription.insertNewObject(forEntityName: "ServerData", into: mycontext);
            if(dicData != nil){
                let strData = dicData?.changeToString()
                inserInfo.setValue(true, forKey: "isAllData");
                inserInfo.setValue(currentDate, forKey: "time");
                inserInfo.setValue(currentDate, forKey: "compareDate");
                inserInfo.setValue(strData, forKey: "changedData");
                
            }else{
                inserInfo.setValue(false, forKey: "isAllData");
                inserInfo.setValue(currentDate, forKey: "time");
                inserInfo.setValue(CurServerData.shared.curDataDate, forKey: "compareDate");
                inserInfo.setValue("", forKey: "changedData");
            }
            try mycontext.save()
        }catch{
            fatalError();
        }
    }
    //清除coreData中的数据
    func delCoreData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyStudents");
        do{
            let rels = try mycontext.fetch(request) as! [NSManagedObject];
            for rel in rels{
                mycontext.delete(rel);
            }
            try mycontext.save();
            let myAlert = UIAlertController(title: "提示", message: "清空数据库成功", preferredStyle: .alert);
            let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
            myAlert.addAction(myOkAction);
            present(myAlert, animated: true, completion: nil);
        }catch{
            fatalError();
        }
    }
    //获取coreData 中的最新一条数据
    func getLatestCoreData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ServerData");
        request.predicate = NSPredicate.init(format: "isAllData = true")
        request.sortDescriptors = [NSSortDescriptor.init(key: "time", ascending: true)]
        let rels = try? mycontext.fetch(request) as? [NSManagedObject];
        let rel = rels?.last
        if rel != nil {
            guard let strData = rel?.value(forKey: "changedData") else {return}
            guard let dicData = NSDictionary.initwithString(strData as! String) else {return}
            CurServerData.shared.dicData = dicData as! [String : String]
            CurServerData.shared.curDataDate = rel?.value(forKey: "time") as! Date
            self.setUIData(dicData)
        }
    }
    func getResultByDate(_ date:Date)->[NSManagedObject]?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ServerData");
        request.predicate = NSPredicate.init(format: "time = %@",date as CVarArg)
        request.sortDescriptors = [NSSortDescriptor.init(key: "time", ascending: true)]
        let rels = try? mycontext.fetch(request) as? [NSManagedObject];
        return rels
    }

}

