//
//  ActionViewController.swift
//  Extension
//
//  Created by Paul Richardson on 22/05/2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
			if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
				if let itemProvider = inputItem.attachments?.first {
					itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
						// do stuff
					}
	@IBOutlet weak var imageView: UIImageView!
	
				}
			}

		}

	}

	@IBAction func done() {
		// Return any edited content to the host app.
		// This template doesn't do anything, so we just echo the passed in items.
		self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
	}


}
