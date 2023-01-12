//
//  NewEntryViewController.swift
//  toDoList
//
//  Created by may on 1/10/23.
//

import UIKit

class NewEntryViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet var textField: UITextField!
	
	var update: (() -> Void)?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		//once enter key is pressed, textfield will be saved
		//need to add textfielddelegate in inherit classes
		textField.delegate = self
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEntry))
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		saveEntry()
		return true
	}
    
	
	@objc func saveEntry(){
		//check if textfield is empty
		guard let text = textField.text, !text.isEmpty else {return}
	
		var todo = UserDefaults().object(forKey: "todo") as? [String:String] ?? [:]
		
		
		let id = UUID().uuidString
		print(id)
		todo[id] = text
		
		UserDefaults().set(todo, forKey: "todo")
		
		
		//if update func exists, call it
		update?()
		
		//go back to root view controller
		navigationController?.popViewController(animated: true)
	}
	

}
