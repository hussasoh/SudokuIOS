//
//  HighScoreViewController.swift
//  SudokoIOS
//
//  Created by Tomislav Busic on 2020-04-10.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

// Author: Tomislav Busic

import UIKit
import FacebookShare

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    
SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        //show success message
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        //show error message
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        //show cancelled message
    }
    
    
    func showShareDialog<C: SharingContent>(_ content: C, mode: ShareDialog.Mode = .automatic) {
        let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        dialog.mode = mode
        dialog.show()
    }

    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.players.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ScoreCell ?? ScoreCell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.players[rowNum].getName()
        tableCell.secondaryLabel.text = String(mainDelegate.players[rowNum].getScore())
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "Share") {
            (action, index) in
            let rowNum = indexPath.row
            print("Share button tapped")
            
            guard let url = URL(string: "https://github.com/hussasoh/SudokuIOS") else { return }
            let content = ShareLinkContent()
            content.contentURL = url
            content.quote = "Take a look at our Sudoko App! My score was \(self.mainDelegate.players[rowNum].getScore())!"
            
            self.showShareDialog(content, mode: .automatic)
        }
        share.backgroundColor = .blue
        return [share]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainDelegate.readDataFromDatabase()

    }
    
    
}
