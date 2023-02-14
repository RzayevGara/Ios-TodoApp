//
//  TableViewCell.swift
//  Todo App
//
//  Created by Rzayev Gara on 11.02.23.
//

import UIKit

protocol AddEventsInVC1 {
    func addNewEvent(indexPath: IndexPath, check: Bool)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var listSwitch: UISwitch!
    
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

    @IBAction func switchTapped(_ sender: UISwitch) {
        testProtocol?.addNewEvent(indexPath: indexPath!, check: sender.isOn)
    }
}
