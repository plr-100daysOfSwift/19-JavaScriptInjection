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
					//
				}
			}

		}

}
