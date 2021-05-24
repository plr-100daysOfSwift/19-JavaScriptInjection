//
//  ScriptsTableViewController.swift
//  Extension
//
//  Created by Paul Richardson on 24/05/2021.
//

import UIKit

class ScriptsTableViewController: UITableViewController {

	struct script {
		var name: String
		var text: String
	}

	var scripts = [script]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Scripts"

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))

		scripts.append(script(name: "url", text: "alert(document.URL);"))
		scripts.append(script(name: "title", text: "alert(document.title);"))

	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return scripts.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)

		cell.textLabel?.text = scripts[indexPath.row].name
		return cell
	}

	@objc func addScript() {

	}
}
