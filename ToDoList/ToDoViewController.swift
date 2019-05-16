//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Thomas Hamburger on 03/12/2018.
//  Copyright © 2018 Thomas Hamburger. All rights reserved.
//

import UIKit

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
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }

    func updateSaveButton() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }

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
        case [1, 0]:
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none

            isEndDatePickerHidden = !isEndDatePickerHidden
            dueDateLabel.textColor = isEndDatePickerHidden ? .black : tableView.tintColor

            tableView.beginUpdates()
            tableView.endUpdates()

        default: break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)

        switch indexPath {
        case [1, 0]:
            return isEndDatePickerHidden ? normalCellHeight : largeCellHeight
        case[2, 0]:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }

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
