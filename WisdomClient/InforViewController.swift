//
//  InforViewController.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/12/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import UIKit

class InforViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = Constants.infoText
        copyrightLabel.text = Constants.copyrightText
        
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }

}
