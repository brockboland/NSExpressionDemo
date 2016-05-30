//
//  DateViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/30/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var dateInputField: UITextField!
    @IBOutlet weak var parsedDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateInputField.text = "2016-05-30T23:00:00Z"
        self.parseDate(self)
    }

    @IBAction func parseDate(sender: AnyObject) {
        guard let text = self.dateInputField.text else {
            self.parsedDateLabel.text = "(can't parse)"
            return
        }
        guard let date = Formatters.iso8601.dateFromString(text) else {
            self.parsedDateLabel.text = "(can't parse)"
            return
        }
        let formattedDate = Formatters.basicDateTimeFormatter.stringFromDate(date)
        self.parsedDateLabel.text = formattedDate
    }

}
