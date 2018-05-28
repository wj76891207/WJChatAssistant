//
//  ViewController.swift
//  WJChatAssistantDemo
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit
import WJChatAssistant
import BDSpeechRecognizer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "cell"
    
    let demos = [
        ["title": "Default", "subtitle": "Use iOS Speech & has no Intent Recognizer"],
        ["title": "Custom", "subtitle": "Use Baidu Speech & MS Luis Intent Recognizer"]
    ]

    @IBOutlet weak var listView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = demos[indexPath.row]["title"]
        cell.detailTextLabel?.text = demos[indexPath.row]["subtitle"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let defaultViewController = WJCAViewController()
            defaultViewController.delegate = self
            defaultViewController.datasource = self
            defaultViewController.chatAssistant.speechRecognizer = WJBDSpeechManager.share
            navigationController?.pushViewController(defaultViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: WJCAViewControllerDatasource {
    
}


extension ViewController: WJCAViewControllerDelegate {
    
}


