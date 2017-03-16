//
//  postTableViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/15/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class postTableViewController: UITableViewController {
    
    var postList = [Post]()
    var selectedIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(addPostViewController.postsListDidUpdate),name: NSNotification.Name(rawValue: notifyPostListUpdate),object: nil)
        Model.instance.getAllPostsAndObserve()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func postsListDidUpdate(notification:NSNotification){
        self.postList = notification.userInfo?["posts"] as! [Post]
        let newList = self.postList.sorted(by: {$0.lastUpdate! > $1.lastUpdate!})
        self.postList = newList
        self.tableView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postTableViewCell
        cell.spinner.startAnimating()
        cell.location!.text = self.postList[indexPath.row].locate
        cell.usr!.text = self.postList[indexPath.row].user
        Model.instance.getImage(urlStr: self.postList[indexPath.row].imageUrl, callback: { (image) in
            cell.imageView!.image = image
            cell.spinner.stopAnimating()
        })
        return cell
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let psDetailsVc = segue.destination as? postDetailsViewController{
            psDetailsVc.user = self.postList[self.selectedIndex!].user
            psDetailsVc.locate = self.postList[self.selectedIndex!].locate
            psDetailsVc.pblishDate = String(describing: self.postList[self.selectedIndex!].lastUpdate!)
            if (self.postList[self.selectedIndex!].dsc != nil){
                psDetailsVc.dsc = self.postList[self.selectedIndex!].dsc
            }
            else {
                psDetailsVc.dsc = ""
            }
            Model.instance.getImage(urlStr: self.postList[self.selectedIndex!].imageUrl, callback: { (image) in
                psDetailsVc.img =  image
            })

        }}
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "presentPostDetails", sender: self)
     }
        
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
