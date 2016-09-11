//
//  ViewController.swift
//  Calculator
//
//  Created by Ольга Выростко on 10.09.16.
//  Copyright © 2016 Ольга Выростко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var expr = Expression(expression: "1+1 / 1")
        print(expr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

