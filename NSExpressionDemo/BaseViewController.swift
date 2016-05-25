//
//  BaseViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGameData()
    }

}

private extension BaseViewController {

    func loadGameData() {
        guard let fileURL = NSBundle.mainBundle().URLForResource("2015data", withExtension: "csv") else {
            assertionFailure("Can't find data file")
            return
        }

        var splitLines: [String]?
        do {
            let allText = try NSString(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding)
            splitLines = allText.componentsSeparatedByString("\n")
        } catch {
            assertionFailure("Failed to load file contents")
            return
        }

        guard let lines = splitLines where lines.count > 0 else {
            assertionFailure("Loaded no lines")
            return
        }

        
    }

}