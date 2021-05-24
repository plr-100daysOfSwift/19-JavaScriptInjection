//
//  ActionViewController.swift
//  Extension
//
//  Created by Paul Richardson on 22/05/2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UITableViewController {

	struct script {
		var name: String
		var text: String
	}

	var scripts = [script]()

	var pageTitle = ""
	var pageURL = ""

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Scripts"

		scripts.append(script(name: "url", text: "alert(document.URL);"))
		scripts.append(script(name: "title", text: "alert(document.title);"))

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))

		if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
					guard let itemDictionary = dict as? NSDictionary else { return }
					guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
					self?.pageTitle = javaScriptValues["title"] as? String ?? ""
					self?.pageURL = javaScriptValues["URL"] as? String ?? ""
				}
			}
		}

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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let script = scripts[indexPath.row].text
		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": script]
		let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
		item.attachments = [customJavaScript]
		extensionContext?.completeRequest(returningItems: [item])
	}

	@objc func addScript() {

	}
}
