//
//  DetailViewController.swift
//  Extension
//
//  Created by Paul Richardson on 24/05/2021.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var scriptTextView: UITextView!

	var name: String?
	var text: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		nameTextField.text = name ?? "Unknown"
		scriptTextView.text = text ?? ""

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))

	}

	@objc func save() {
		guard let text = scriptTextView.text else { return }
		guard let name = nameTextField.text else { return }

		let script = Script(name: name, text: text)
		scripts.append(script)

		let defaults = UserDefaults.standard

		let encoder = JSONEncoder()
		if let encodedScripts = try? encoder.encode(scripts) {
			defaults.set(encodedScripts, forKey: "scripts")
		}
	}

}
