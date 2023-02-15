//
//  ViewController.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var emptyViewCompleted: UIView!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var doneTableView: UITableView!
    
    @IBOutlet weak var addTaskButtonOutlet: UIButton!
    
    var todolist = [Lists]()
    

    

    var donelist = [Lists]()
    var list = [Lists]()
    
    var cdata: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.layer.cornerRadius = 16
        self.doneTableView.layer.cornerRadius = 16
        emptyView.layer.cornerRadius = 16
        emptyViewCompleted.layer.cornerRadius = 16
        self.addTaskButtonOutlet.layer.cornerRadius = 25
        
        readData()
        
        if todolist.count == 0{
            listTableView.isHidden = true
            emptyView.isHidden = false
            emptyViewCompleted.isHidden = false
        }else{
            listTableView.isHidden = false
            emptyView.isHidden = true
            emptyViewCompleted.isHidden = true
        }

        donelist = todolist.filter{$0.listDone}
        list = todolist.filter{$0.listDone == false}

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
    
    func readData(){
        do{
            // users core datasina istek atiriq, datalari aliriq
            todolist = try context.fetch(Lists.fetchRequest())
        }catch{
            print("error read data")
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dataCount :Int? = 0
        
        if todolist.count == 0{
            listTableView.isHidden = true
            emptyView.isHidden = false
            emptyViewCompleted.isHidden = false
        }else{
            listTableView.isHidden = false
            emptyView.isHidden = true
            emptyViewCompleted.isHidden = true
            if tableView == listTableView{
                dataCount = list.count
            }
            if tableView == doneTableView{
                dataCount = donelist.count
            }
        }
        return dataCount!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comingData = tableView == listTableView ? list[indexPath.row] : donelist[indexPath.row]

        if tableView == listTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! TableViewCell
            cell.titleLabel.text = comingData.listTitle!
            cell.timeLabel.text = comingData.listTime!
            cell.listSwitch.isOn = comingData.listDone
            cell.testProtocol = self
            cell.indexPath = indexPath
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneList", for: indexPath) as! TableViewCell2
            cell.doneTitleLabel.attributedText = comingData.listTitle!.strikeThrough()
            cell.doneTimeLabel.attributedText = comingData.listTime!.strikeThrough()
            cell.doneListSwitch.isOn = comingData.listDone
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
        let listUpdate = todolist[indexPath.row]
        listUpdate.listDone = check
        appDelegate.saveContext()
        
        readData()

        donelist = todolist.filter{$0.listDone}
        list = todolist.filter{$0.listDone == false}
        listTableView.reloadData()
        doneTableView.reloadData()
    }
}

extension ViewController: sendDatainVC1 {
    func addNewEvent(id: String?, title: String?, time: String?, notes: String?, listDone: Bool?) {
        if todolist.contains(where: { user in user.listID == id! }){
            if let index = todolist.firstIndex(where: { user in user.listID == id! }) {
                let list = todolist[index]
                list.listTitle = title!
                list.listTime = time!
                list.listNotes = notes!
                appDelegate.saveContext()
            }
        }else{
            let list  = Lists(context: context)
            
            list.listID = id!
            list.listTitle = title!
            list.listTime = time!
            list.listNotes = notes!
            list.listDone = false
            appDelegate.saveContext()
        }
        readData()
        donelist = todolist.filter{$0.listDone}
        list = todolist.filter{$0.listDone == false}
        listTableView.reloadData()
        doneTableView.reloadData()
    }
    
    func deletedIndex(id: String?) {
        if let index = todolist.firstIndex(where: { user in user.listID == id! }) {
            let list = todolist[index]
            context.delete(list)
            appDelegate.saveContext()
        }
        readData()
        donelist = todolist.filter{$0.listDone}
        list = todolist.filter{$0.listDone == false}
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
