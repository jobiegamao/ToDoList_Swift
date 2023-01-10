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
		
		// get and set todos count
		guard var count = UserDefaults().value(forKey: "count") as? Int else {return}
		count += 1
		print(count)
		UserDefaults().setValue(count, forKey: "count")
		UserDefaults().setValue(text, forKey: "task_\(count)")
		
		//if update func exists, call it
		update?()
		
		//go back to root view controller
		navigationController?.popViewController(animated: true)
	}
	

}
