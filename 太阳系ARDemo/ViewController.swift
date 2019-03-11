//
//  ViewController.swift
//  太阳系ARDemo
//
//  Created by 韩云智 on 2017/10/2.
//  Copyright © 2017年 韩云智. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickBtn(_ sender: UIButton) {
        let vc = SCenViewViewController.init()
        self.present(vc, animated: true, completion: nil)
    }
    
}

