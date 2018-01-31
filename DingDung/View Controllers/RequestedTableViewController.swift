//
//  RequestedTableViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 30-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Foundation

import Firebase

class RequestedTableViewController: UITableViewController {

    let databaseReference = Database.database().reference()
    let requestReference = Database.database().reference().child("requests")
    let userInfoReference = Database.database().reference().child("users")
    let userID = Auth.auth().currentUser?.uid

    var allRequests = [Request]()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getRequests()
    }
    
    func getRequests() {
        
        requestReference.child("current").observe(.childAdded) { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                if request["receiver"] as? String == self.userID! &&
                    request["status"] as? String == "pending" {
                    
                    let newRequest = Request()
                    
                    newRequest.timestamp = request["timestamp"] as? Double
                    
                    let user = request["sender"] as! String
                    
                    self.userInfoReference.child(user).observeSingleEvent(of: .value) { (snapshot) in
                        if let request = snapshot.value as? [String: AnyObject] {
                        
                            newRequest.username = request["username"] as? String
                            newRequest.sender = user
                            
                            self.allRequests.append(newRequest)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRequests.count
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleRequest", for: indexPath) as! RequestTableViewCell
        
        let currentTime = NSDate().timeIntervalSince1970
        let minutesPassed = allRequests[indexPath.row].calculateMinutes(currentTime)

        cell.selectionStyle = .none
        cell.someMinutesAgo.text = "\(minutesPassed) minutes ago"
        cell.username.text = allRequests[indexPath.row].username!
        
        cell.delegate = self
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RequestedTableViewController: RequestTableViewDelegate {
    
    func requestWasAccepted(_ sender: RequestTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        let requestAccepted = allRequests[tappedIndexPath.row]
        
        requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: String] {
                
                let senderPrint = request["sender"]
                
                if senderPrint == requestAccepted.sender {
                    
                    self.areYouSure("accept", key: snapshot.key, path: tappedIndexPath.row)
                    return
                }
            }
        })
    }
    
    func requestWasDenied(_ sender: RequestTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        let requestDenied = allRequests[tappedIndexPath.row]
        
        requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: String] {
                
                if request["sender"] ==  requestDenied.sender &&
                    request["receiver"] == self.userID! {
                    
                    self.areYouSure("deny", key: snapshot.key, path: tappedIndexPath.row)
                    return
                }
            }
        })
    }
    
    func areYouSure(_ status: String, key: String, path: Int) {
        
        let alert = UIAlertController(title: "Info",
                                      message: "Are you sure you want to \(status) this request?",
            preferredStyle: UIAlertControllerStyle.alert)
        
        let pressCancel = UIAlertAction(title:"Cancel",
                                        style: UIAlertActionStyle.destructive,
                                        handler: { action in
        })
        
        let pressOK = UIAlertAction(title:"Yes",
                                    style: UIAlertActionStyle.default,
                                    handler: { action in
                                        
                                        if status == "accept" {
                                            self.requestReference.child("current")
                                                .child(key).updateChildValues(["status": "accepted"])
                                        } else {
                                            self.requestReference.child("current")
                                                .child(key).updateChildValues(["status": "denied"])
                                        }
                                        
                                        self.allRequests.remove(at: path)
                                        self.tableView.reloadData()
        })
        
        alert.addAction(pressOK)
        alert.addAction(pressCancel)
        present(alert, animated: true, completion: nil)
    }
}

