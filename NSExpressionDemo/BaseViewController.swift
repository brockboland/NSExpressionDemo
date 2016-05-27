//
//  BaseViewController.swift
//  NSExpressionDemo
//
//  Created by Brock Boland on 5/24/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

import UIKit
import CoreData

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

    var managedObjectContext: NSManagedObjectContext!

    private var games: [Game] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGameData()

        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "opponent", ascending: true)]
        let results = try? self.managedObjectContext.executeFetchRequest(fetchRequest)
        self.games = results as? [Game] ?? []

        self.tableView.reloadData()
        self.tableView.dataSource = self
    }

}

//MARK: IBActions

private extension BaseViewController {

    @IBAction func calculateSum() {
        let sumFieldName = "sumField"

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = sumFieldName
        expressionDescription.expressionResultType = .Integer64AttributeType
        expressionDescription.expression = NSExpression(forFunction: "sum:",
                                                        arguments:[NSExpression(forKeyPath: "runs")])

        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .DictionaryResultType

        let results = try? self.managedObjectContext.executeFetchRequest(fetchRequest)

        guard let
            resultDict = results?.first as? [String: Int],
            sum = resultDict[sumFieldName] else {
                self.showAlert("FAIL")
                return
        }
        self.showAlert("Total: \(sum) runs")
    }

    @IBAction func calculateAverage() {
        let averageFieldName = "averageField"
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = averageFieldName
        expressionDescription.expressionResultType = .FloatAttributeType
        expressionDescription.expression = NSExpression(forFunction: "average:",
                                                        arguments:[NSExpression(forKeyPath: "runs")])

        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .DictionaryResultType

        let results = try? self.managedObjectContext.executeFetchRequest(fetchRequest)

        guard let
            resultDict = results?.first as? [String: AnyObject],
            average = resultDict[averageFieldName] else {
                self.showAlert("FAIL")
                return
        }
        self.showAlert("Average: \(average) runs")
    }

}

//MARK: Data loading

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

        for line in lines {
            let fields = line.componentsSeparatedByString(",")
            guard fields.count == 6 else {
                print("Not enough fields on line")
                continue
            }
            
            let game = NSEntityDescription.insertNewObjectForEntityForName("Game",
                                                                           inManagedObjectContext: self.managedObjectContext) as! Game

            game.gameNumber = self.intFromString(fields[CSVField.GameNumber.rawValue])
            game.date = self.dateFromString(fields[CSVField.Date.rawValue])
            game.opponent = fields[CSVField.Opponent.rawValue]
            game.runs = self.intFromString(fields[CSVField.Runs.rawValue])
            game.runsAgainst = self.intFromString(fields[CSVField.RunsAgainst.rawValue])
            game.attendees = self.intFromString(fields[CSVField.Attendees.rawValue])
        }

        try? self.managedObjectContext.save()
    }

    private func intFromString(string: String?) -> Int {
        return Formatters.intFormatter.numberFromString(string ?? "")?.integerValue ?? 0
    }

    private func dateFromString(string: String?) -> NSDate {
        return Formatters.dateFormatter.dateFromString(string ?? "") ?? NSDate()
    }

}

//MARK: Error
extension BaseViewController {

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

//MARK: UITableViewDataSource
extension BaseViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)

        let game = self.games[indexPath.row]

        let date = Formatters.friendlyDateFormatter.stringFromDate(game.date)
        cell.textLabel?.text = (game.opponent ?? "") + " on \(date)"
        cell.detailTextLabel?.text = "\(game.runs) - \(game.runsAgainst)"
        return cell
    }

}
