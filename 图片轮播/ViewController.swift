//
//  ViewController.swift
//  图片轮播
//
//  Created by qzp on 15/12/11.
//  Copyright © 2015年 qzp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imgs: [UIImage] = [UIImage(named: "0.jpg")!,
            UIImage(named: "1.jpg")!,UIImage(named: "2.jpg")!,UIImage(named: "3.jpg")!]
        
        let qv = QImageScrollView(frame: CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 200), images:imgs )
        self.view.addSubview(qv)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

