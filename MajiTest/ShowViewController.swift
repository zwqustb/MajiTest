//
//  ShowViewController.swift
//  MajiTest
//
//  Created by 张文强 on 2021/2/18.
//

import UIKit
import CoreData
class ShowViewController: UIViewController {

    let fullsize = UIScreen.main.bounds.size;
    let myEntity = "ServerData";
    var myContext : NSManagedObjectContext!;
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ServerData");
    var myTextView : UITextView!;
    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        super.viewDidLoad()

        self.title = "显示数据";
        self.view.backgroundColor = UIColor.white;
        
        myTextView = UITextView(frame: CGRect(x: 0, y: 0, width: fullsize.width, height: fullsize.height));
        myTextView.center = CGPoint(x: fullsize.width * 0.5, y: fullsize.height * 0.5);
        myTextView.textAlignment = .left;
        myTextView.textColor = UIColor.red;
        myTextView.isEditable = false;
        self.view.addSubview(myTextView);
        show();
    }

    func show(){
        do{
            let rels = try myContext.fetch(request) as! [NSManagedObject];
            var re = "";
            for rel in rels {
                if rel.value(forKey: "time") != nil{
                    re += "\n本次请求时间:\(rel.value(forKey: "time")!)\n" + "返回数据内容相等于时间: \(rel.value(forKey: "compareDate")!)\n" + "实际保存的数据:\(rel.value(forKey: "changedData")!)\n" + "是否保存了完整的数据:\(rel.value(forKey: "isAllData")!)\n";
                }
            }
            if re != ""{
                myTextView.text = re;
            }else{
                myTextView.text = "未找到相关数据！";
                myTextView.textColor = UIColor.red;
            }
        }catch{
            fatalError();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
