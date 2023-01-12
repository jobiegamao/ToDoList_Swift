//
//  ViewController.swift
//  toDoList
//
//  Created by may on 1/10/23.
//

import UIKit

class ViewController: UIViewController {

	var todo = [String: String]()
	var todoIDs = [String]()
	
	@IBOutlet var addBtn: UIBarButtonItem!
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.isToolbarHidden = false
		self.title = "To Do List"
		
		tableView.delegate = self
		tableView.dataSource = self
		
//		SETUP of data using UserDefaults
		
		//if not yet set
		if !UserDefaults().bool(forKey: "setup"){
			UserDefaults().set(true, forKey: "setup")
			UserDefaults().set(todo, forKey: "todo")
		}
		
//		get all current saved tasks
		updateList()
		
	}

	
	@IBAction func didTapAddBtn(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "newEntry") as! NewEntryViewController
		vc.title = "New Task"
		vc.update = {
			DispatchQueue.main.async {
				self.updateList()
			}
		}
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func updateList(){
		
		
		todo.removeAll()
//		//use guard let since tasks is optional, non-existant on first run
		
		guard let tasks = UserDefaults().value(forKey: "todo") as? [String:String] else {
			return
		}

		for (id, text) in tasks{
			todo[id] = text
		}
		todoIDs = Array(todo.keys)
		
		tableView.reloadData()
	}
	
	func deleteTask(id: String){
		print(id)
		guard (todo[id] != nil) else {return}
		todo.removeValue(forKey: id)
		UserDefaults().set(todo, forKey: "todo")
	}
	
}


	

// extentions for table view

extension ViewController: UITableViewDelegate {
	
	//when cell is tapped
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//to unselect after selecting the cell
		tableView.deselectRow(at: indexPath, animated: true)
		
		let vc = storyboard?.instantiateViewController(withIdentifier: "viewEntry") as! ViewEntryViewController
		vc.title = "Task \(indexPath)"
	}
}


extension ViewController: UITableViewDataSource {
	
	//how many cells
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todo.count
	}
	
	//display the stuffToDo in cells
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = todo[todoIDs[indexPath.row]]
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			print("id to delete:", todoIDs[indexPath.row])
			deleteTask(id: todoIDs[indexPath.row])
			//auto reloads table after
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
