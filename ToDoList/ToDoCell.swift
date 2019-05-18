//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Thomas Hamburger on 03/12/2018.
//  Copyright © 2018 Thomas Hamburger. All rights reserved.
//

import UIKit

// Protocol die de cel terug geeft aan de delegate.
@objc protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

// Model die een enkele cel in de ToDo Table View representeert.
class ToDoCell: UITableViewCell {

    var delegate: ToDoCellDelegate?

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBAction func completeButtonTapped() {
        delegate?.checkmarkTapped(sender: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
