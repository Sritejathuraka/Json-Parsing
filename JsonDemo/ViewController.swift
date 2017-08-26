//
//  ViewController.swift
//  JsonDemo
//
//  Created by Sriteja Thuraka on 7/28/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var loans = [Loan]()
    
    // End point for parse the data
    let url = "https://api.kivaws.org/v1/loans/newest.json"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        getData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK:- UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return loans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MainTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.nameLabel.text = loans[indexPath.row].name
        cell?.countryLabel.text = loans[indexPath.row].country
        cell?.amountLabel.text = "$\(loans[indexPath.row].amount)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    // MARK: - Methods for parse the data
    func getData() {
        
        guard let loanUrl = URL(string: url) else {
            return
        }
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                
                print(error)
                return
            }
            if let data = data {
                
                self.loans = self.parseJson(data: data)
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        }
        
        task.resume()
    }
    
    func parseJson(data: Data) -> [Loan] {
        
        var loans = [Loan]()
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            for jsonLoan in jsonLoans {
                
                let loan = Loan()
                loan.name = jsonLoan["name"] as! String
                let location = jsonLoan["location"] as! [String: AnyObject]
                loan.country = location["country"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                loans.append(loan)
                
            }
            
        }catch {
            
            print("Error: \(error.localizedDescription)")
        }
        return loans
    }
    
}


