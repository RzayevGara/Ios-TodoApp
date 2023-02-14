//
//  AddNewListVC.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import UIKit

protocol sendDatainVC1 {
    func addNewEvent(event: List)
    func deletedIndex(id: String?)
}

class AddNewListVC: UIViewController {
    var alertController = UIAlertController()
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    var testProtocol:sendDatainVC1?
    
    var timePicker: UIDatePicker?
    
    var comingDataVC: List?
    var comingID: String? = UUID().uuidString
    
    var showButton: Bool? = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButtonOutlet.layer.cornerRadius = 25
        
        self.deleteButtonOutlet.layer.cornerRadius = 25
        
        titleTextField.text = comingDataVC?.listTitle
        
        timeTextField.text = comingDataVC?.listTime
        
        notesTextField.text = comingDataVC?.listNotes
        
        if showButton!{
            deleteButtonOutlet.isHidden = false
        }
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.locale = Locale.init(identifier: "en")
        timeTextField.inputView = timePicker
        
        timePicker?.addTarget(self, action: #selector(self.showTime(timePicker:)), for: .valueChanged)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.tuchAction))
        view.addGestureRecognizer(touch)
        
        titleTextField?.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    @objc func tuchAction(){
        view.endEditing(true) //her deyisiklik etdikde pencere baglanir
    }
    
    @objc func showTime(timePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let pickingDate = dateFormatter.string(from: timePicker.date)
        timeTextField.text = pickingDate
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if titleTextField.text != "" {
            titleTextField.layer.borderWidth = 0
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        if titleTextField.text != ""{
            testProtocol?.addNewEvent(event: List(listID: comingID!, listTitle: "\(titleTextField.text!)", listTime: "\(timeTextField.text!)", listNotes: "\(notesTextField.text!)", listDone: false))
            self.dismiss(animated: true)
        }else{
            titleTextField.layer.borderWidth = 1
            titleTextField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        presentAlert(title: "Are you sure?", message: nil, cancelButtonTitle: "Cancel", addButtonTitle: "Delete", defaultButtonHandler: {_ in
            self.testProtocol?.deletedIndex(id: self.comingID)
            self.dismiss(animated: true)
        })
    }
    
    
    func presentAlert(title: String?,
                      message: String?,
                      preferedStyle: UIAlertController.Style = .alert,
                      cancelButtonTitle: String?,
                      addButtonTitle: String? = nil,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandler: ((UIAlertAction)->Void)? = nil
    ){
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferedStyle)
        if addButtonTitle != nil{
            let defaultButton = UIAlertAction(title: addButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel)
        if isTextFieldAvailable{
            alertController.addTextField()
        }
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    
}
