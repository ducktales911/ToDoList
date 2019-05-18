//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Thomas Hamburger on 03/12/2018.
//  Copyright © 2018 Thomas Hamburger. All rights reserved.
//

import UIKit

// View controller voor het scherm voor het bewerken van een enkele todo.
class ToDoViewController: UITableViewController {

    var isEndDatePickerHidden = true

    var todo: ToDo?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButton()
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    // dueDatePickerView reflecteert altijd wat in de datePicker staat.
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }

    // Schakel save knop uit als het titel tekstveld nog leeg is.
    func updateSaveButton() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    // Zet de datum gegeven als paramenter in de dueDateLabel.
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }

    // Gebruik ingevulde informatie om een ToDo object te initialiseren.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind" else { return }

        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text

        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch indexPath {
        case [1, 0]: // Due date cel
            // Voorkom highlighting van de cel.
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none

            isEndDatePickerHidden = !isEndDatePickerHidden
            dueDateLabel.textColor = isEndDatePickerHidden ? .black : tableView.tintColor

            // Animeer de celhoogte aanpassing.
            tableView.beginUpdates()
            tableView.endUpdates()

        default: break
        }
    }

    // Geef Basic Info sectie hoogte 44, Notes sectie hoogte 200. En de Due Date cell een conditionele hoogte van 44 wanneer de endDatePicker verborgen is en 200 wanneer de endDatePicker geopend is.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)

        switch indexPath {
        case [1, 0]: // Due Date cel
            return isEndDatePickerHidden ? normalCellHeight : largeCellHeight
        case[2, 0]: // Notes cel
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }

    // Als deze viewController een object ontvangt, toon de view met de data ingevuld. Zo niet, toon dan de view zonder ingevulde velden en zet de startwaade van datePickerView 24 uur vanaf nu .
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }

        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButton()
    }

}
