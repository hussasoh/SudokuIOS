//
//  HighScoreViewController.swift
//  SudokoIOS
//
//  Created by Tomislav Busic on 2020-04-10.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

import UIKit
import FacebookShare

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    
// Facebook Sharing delegate needed to share our content
SharingDelegate {
    
    // if the share is unsuccessful
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("Failed share")
    }
    
    // if the share fails with an error
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Error with share")
    }
    
    // if the share is cancelled
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share cancelled")
    }
    
    // The function used to show the content is defined. Will use it later
    func showShareDialog<C: SharingContent>(_ content: C, mode: ShareDialog.Mode = .automatic) {
        let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        dialog.mode = mode
        dialog.show()
    }
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate  // Define our app delegate
    
    // Initalizes the number of cells to the number of players found in our Player data holder array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.players.count
    }
    
    // sets the height of each row to 60
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // sets the what the content of each row will be inside the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ScoreCell ?? ScoreCell(style: .default, reuseIdentifier: "cell")
        
        // Row number is defined as the index path number of each row
        let rowNum = indexPath.row
        // For each primary / secondary label, set the text as the players name and score, respectively.
        tableCell.primaryLabel.text = mainDelegate.players[rowNum].getName()
        tableCell.secondaryLabel.text = String(mainDelegate.players[rowNum].getScore())
        
        // Set the sudoku image for each cell
        let img = UIImage(named: "sudoku_normal.png")
        tableCell.myImageView.image = img
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    // sets the actions (swiping right). Here we will have a share button that will share to Facebook
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .normal, title: "Share on Facebook") {
            (action, index) in
            let rowNum = indexPath.row // attactaches the row number, to the index path selected
            guard let url = URL(string: "https://github.com/hussasoh/SudokuIOS") else { return }    // URL that it will share
            let content = ShareLinkContent()  // the shared content which will be shared
            content.contentURL = url          // our url previously initliazed is added to the content URL
            
            // The text that will be posted on the Facebook feed is added to the content
            content.quote = "Take a look at our Sudoko App! My score was \(self.mainDelegate.players[rowNum].getScore())!"
            // Content is shared
            self.showShareDialog(content, mode: .automatic)
        }

        share.backgroundColor = .blue
        return [share]
        
    }
    
    // on load we will be reading from database to fill the table view with entries
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readDataFromDatabase()

    }
    
    
}
