//
//  BaseViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private enum CSVField: Int {
        case
        GameNumber,
        Date,
        Opponent,
        Runs,
        RunsAgainst,
        Attendees
    }

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

        let coreDataManager = CoreDataManager()

        for line in lines {
            let fields = line.componentsSeparatedByString(",")
            
            let game = coreDataManager.newGame()
            game.gameNumber = self.intFromString(fields[CSVField.GameNumber.rawValue])
            game.date = self.dateFromString(fields[CSVField.Date.rawValue])
            game.opponent = fields[CSVField.Opponent.rawValue]
            game.runs = self.intFromString(fields[CSVField.Runs.rawValue])
            game.runsAgainst = self.intFromString(fields[CSVField.RunsAgainst.rawValue])
            game.attendees = self.intFromString(fields[CSVField.Attendees.rawValue])
        }
    }

    private func intFromString(string: String?) -> Int {
        return Formatters.intFormatter.numberFromString(string ?? "")?.integerValue ?? 0
    }

    private func dateFromString(string: String?) -> NSDate {
        return Formatters.dateFormatter.dateFromString(string ?? "") ?? NSDate()
    }

}