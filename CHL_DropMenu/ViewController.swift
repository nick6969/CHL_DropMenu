//
//  ViewController.swift
//  CHL_DropMenu
//
//  Created by nickLin on 2017/5/21.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController , CHL_DropMenuDelegate{

    let showButton : CHL_DropMenu = CHL_DropMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        view.addSubview(showButton)
        showButton.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        showButton.delegate = self
        showButton.backgroundColor = .white
        showButton.showDatas = ["愛因斯坦","牛頓","法拉地","海森堡","阿基米德"]
        showButton.titleLabel.text = "物理學家們"
        showButton.rowHeight = 50
        showButton.maxTableHeight = 200
        showButton.menuLeavlSpace = 10
    }

    // CHL_DropMenuDelegate
    func didSelect(title:String,index:Int)
    {
        print("select title: \(title)")
        print("select index: \(index)")
    }
    

}

