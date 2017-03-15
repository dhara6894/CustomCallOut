//
//  SecondViewController.swift
//  MapkitDemo
//
//  Created by dhara.patel on 14/03/17.
//  Copyright © 2017 SA. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var sName = String()
    var sAddress = String()
    var sImage = UIImage()
    
    @IBOutlet weak var IBimgView: UIImageView!
    @IBOutlet weak var IBlblName: UILabel!
    @IBOutlet weak var IBlblAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        IBlblName.text = sName
        IBlblAddress.text = sAddress
        IBimgView.image = sImage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
