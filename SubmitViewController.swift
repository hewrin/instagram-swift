//
//  SubmitViewController.swift
//  InstagramClone
//
//  Created by Faris Roslan on 25/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {
    @IBAction func onUploadButtonPressed(sender: AnyObject) {
    }
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var captionTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
