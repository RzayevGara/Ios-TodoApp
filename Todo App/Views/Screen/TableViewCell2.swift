//
//  TableViewCell2.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import UIKit

protocol AddEventsInVC1Second {
    func addNewEvent(indexPath: IndexPath, check: Bool)
}

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var doneTitleLabel: UILabel!
    
    
    @IBOutlet weak var doneListSwitch: UISwitch!
    
    @IBOutlet weak var doneTimeLabel: UILabel!
    
    var testProtocol:AddEventsInVC1?
    
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        testProtocol?.addNewEvent(indexPath: indexPath!, check: sender.isOn)
    }
}
