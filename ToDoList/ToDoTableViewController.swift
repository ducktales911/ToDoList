//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Thomas Hamburger on 03/12/2018.
//  Copyright © 2018 Thomas Hamburger. All rights reserved.
//

import UIKit

// Geeft een collectie van ToDo objecten weer.
class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    // Collectie van ToDo items.
    var todos = [ToDo]()

    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }

    // Als een ToDo object aangemaakt is door ToDoViewController, voeg een cel toe aan de tabel die de nieuwe data representeert.
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController

        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }

    // Als een rij wordt geselecteerd, toon de bijbehorende ToDo obect in de ToDo view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }

        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    // Er is rij voor elke todo.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    // Stelt de cellen van de tableView in.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Probeert een cel, gedowncast als ToDoCell, te dequeuen. Faalt als dit niet lukt.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
            fatalError("Could not dequeue a cell")
        }

        // Haal de model uit de array die correspondeert met de weer te geven cel.
        let todo = todos[indexPath.row]
        // Update de eigenschappen van de cel.
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.delegate = self
        return cell

    }

    // Nodig om swipe-to-delete mogelijk te maken.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Bij een swipe-to-delete, verwijder het model uit de array en uit de table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
}
