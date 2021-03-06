//
//  ActionViewController.swift
//  Extension
//
//  Created by Paul Richardson on 22/05/2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

	@IBOutlet var script: UITextView!

	var pageTitle = ""
	var pageURL = ""

	var host: String {
		let url = URL(string: pageURL)
		return url?.host ?? ""
	}

	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Presets", style: .plain, target: self, action: #selector(choosePreset))

		if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
					guard let itemDictionary = dict as? NSDictionary else { return }
					guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
					self?.pageTitle = javaScriptValues["title"] as? String ?? ""
					self?.pageURL = javaScriptValues["URL"] as? String ?? ""
					DispatchQueue.main.async {
						self?.title = self?.pageTitle
						self?.loadScript()
					}
				}
			}
		}

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

	}

	@IBAction func done() {

		save()

		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
		let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
		item.attachments = [customJavaScript]
		extensionContext?.completeRequest(returningItems: [item])

	}

	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

		if notification.name == UIResponder.keyboardWillHideNotification {
			script.contentInset = .zero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}

		script.scrollIndicatorInsets = script.contentInset

		let selectedRange = script.selectedRange
		script.scrollRangeToVisible(selectedRange)
	}

	@objc func choosePreset() {
		let presets = ["alert(document.title);",
									 "alert(document.URL);"]
		let ac = UIAlertController(title: "Choose a Preset", message: nil, preferredStyle: .alert)
		for preset in presets {
			ac.addAction(UIAlertAction(title: preset, style: .default, handler: { action in
				self.script.text = preset
			}))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	func save() {
		guard !script.text.isEmpty else { return }
		guard !host.isEmpty else { return }
		defaults.set(script.text, forKey: host)
	}

	func loadScript() {
		guard !host.isEmpty else { return }

		if let savedScript = defaults.string(forKey: host) {
			script.text = savedScript
		}
	}

}
