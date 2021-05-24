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
	var script: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		nameTextField.text = name ?? "Unknown"
		scriptTextView.text = script ?? ""

	}

}
