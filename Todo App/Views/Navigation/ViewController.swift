//
//  ViewController.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var doneTableView: UITableView!
    
    @IBOutlet weak var addTaskButtonOutlet: UIButton!
    var todolist = [List]()
    
    var donelist = [List]()
    var list = [List]()
    
    var cdata: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.layer.cornerRadius = 16
        self.doneTableView.layer.cornerRadius = 16
        self.addTaskButtonOutlet.layer.cornerRadius = 25
        
        let list1 = List(listID: "1", listTitle: "tes1", listTime: "11:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: true)
        let list2 = List(listID: "2", listTitle: "tes2", listTime: "12:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        let list3 = List(listID: "3", listTitle: "tes3", listTime: "13:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        let list4 = List(listID: "4", listTitle: "tes4", listTime: "14:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        let list5 = List(listID: "5", listTitle: "tes5", listTime: "15:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        let list6 = List(listID: "6", listTitle: "tes6", listTime: "16:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        let list7 = List(listID: "7", listTitle: "tes7", listTime: "17:00", listNotes: "asn jd asd h jhqwg dj qwd", listDone: false)
        todolist.append(list1)
        todolist.append(list2)
        todolist.append(list3)
        todolist.append(list4)
        todolist.append(list5)
        todolist.append(list6)
        todolist.append(list7)
        
        
        donelist = todolist.filter{$0.listDone!}
        list = todolist.filter{$0.listDone! == false}
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        doneTableView.dataSource = self
        doneTableView.delegate = self
        
    }


    @IBAction func addNewTask(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "test") as? AddNewListVC {
            vc.testProtocol = self
            self.present(vc, animated: true)
         }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dataCount :Int?

        if tableView == listTableView{
            dataCount = list.count
        }
        if tableView == doneTableView{
            dataCount = donelist.count
        }

        return dataCount!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comingData = tableView == listTableView ? list[indexPath.row] : donelist[indexPath.row]
        
        if tableView == listTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! TableViewCell
            cell.titleLabel.text = comingData.listTitle!
            cell.timeLabel.text = comingData.listTime!
            cell.listSwitch.isOn = comingData.listDone!
            cell.testProtocol = self
            cell.indexPath = indexPath
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneList", for: indexPath) as! TableViewCell2
            cell.doneTitleLabel.attributedText = comingData.listTitle!.strikeThrough()
            cell.doneTimeLabel.attributedText = comingData.listTime!.strikeThrough()
            cell.doneListSwitch.isOn = comingData.listDone!
            cell.testProtocol = self
            cell.indexPath = indexPath
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "test") as? AddNewListVC {
             vc.testProtocol = self
            vc.showButton = true
            if tableView == listTableView{
                vc.comingDataVC = list[indexPath.row]
                vc.comingID = list[indexPath.row].listID
            }else{
                vc.comingDataVC = donelist[indexPath.row]
                vc.comingID = donelist[indexPath.row].listID
            }
            self.present(vc, animated: true)
         }
    }
}


extension ViewController: AddEventsInVC1, AddEventsInVC1Second{
    func addNewEvent(indexPath: IndexPath, check: Bool){
        if check {
            let data = list[indexPath.row]
            data.listDone = check
        }else{
            let data = donelist[indexPath.row]
            data.listDone = check
        }
        donelist = todolist.filter{$0.listDone!}
        list = todolist.filter{$0.listDone! == false}
        listTableView.reloadData()
        doneTableView.reloadData()
    }
}

extension ViewController: sendDatainVC1 {
    func deletedIndex(id: String?) {
        todolist = todolist.filter{$0.listID != id}
        donelist = todolist.filter{$0.listDone!}
        list = todolist.filter{$0.listDone! == false}
        listTableView.reloadData()
        doneTableView.reloadData()
    }
    
    func addNewEvent(event: List) {
        if todolist.contains(where: { user in user.listID == event.listID! }){
            todolist.forEach{user in
                if user.listID == event.listID! {
                    user.listTitle = event.listTitle!
                    user.listTime = event.listTime!
                    user.listNotes = event.listNotes!
                }
            }
        }else{
            todolist.append(event)
        }
        donelist = todolist.filter{$0.listDone!}
        list = todolist.filter{$0.listDone! == false}
        listTableView.reloadData()
        doneTableView.reloadData()
    }
}


extension String {
    func strikeThrough() -> NSAttributedString {
         let attributeString =  NSMutableAttributedString(string: self)
         attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
         return attributeString
    }
}
