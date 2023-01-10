//
//  ViewController.swift
//  toDoList
//
//  Created by may on 1/10/23.
//

import UIKit

class ViewController: UIViewController {

	var stuffToDos = [String]()
	
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
			print("hello")
			UserDefaults().set(true, forKey: "setup")
			UserDefaults().set(0, forKey: "count")
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
		
		stuffToDos.removeAll()
		
		//use guard let since count is optional, non-existant on first run
		guard let count = UserDefaults().value(forKey: "count") as? Int else{
			return
		}
		
		for i in 0..<count {
			if let aToDo = UserDefaults().value(forKey: "task_\(i+1)") as? String {
				stuffToDos.append(aToDo)
			}
		}
		
		tableView.reloadData()
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
		return stuffToDos.count
	}
	
	//display the stuffToDo in cells
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = stuffToDos[indexPath.row]
		return cell
	}
}
