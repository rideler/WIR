//
//  postDetailsViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/15/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

/**
 view controller for the post details, this class shows all the details about selected post
 */
class postDetailsViewController: UIViewController {

    @IBOutlet weak var descIMG: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var lction: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var usrName: UILabel!
    
    var img: UIImage?
    var dsc: String?
    var locate: String?
    var pblishDate: Date?
    var user: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initilazing all the members of the view controller
        self.descIMG.image = img
        self.desc.text = dsc
        self.lction.text = locate
        self.publishDate.text = pblishDate?.stringValue
        self.usrName.text = user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     this func returns you to the root page of the social tab when exiting this page
 
    */
    open override func viewDidDisappear(_ animated: Bool) {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
