//
//  CHL_DropMenu.swift
//  CHL_DropMenu
//
//  Created by nickLin on 2017/5/21.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

public protocol CHL_DropMenuDelegate : class
{
    func didSelect(title:String,index:Int)
}

public class CHL_DropMenu: UIControl {

    // UI
    public let titleLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate var table : UITableView?
    
    // Data
    public var showDatas : [String] = []
    fileprivate var downImage : UIImage? = UIImage(named:"default_down")
    fileprivate var upImage : UIImage?  = UIImage(named:"default_up")
    
    
    // static value
    fileprivate let reuseIdentifier = "Cell"
    fileprivate let duration = 0.25
    
    // use Setting
    public var rowHeight : CGFloat = 50
    public var maxTableHeight : CGFloat = 300
    public var menuLeavlSpace : CGFloat = 0
    public var isMenuShowing : Bool { return table != nil }
    public weak var delegate : CHL_DropMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTarget()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupTarget()
    }
    
    fileprivate func setupTarget()
    {
        self.addTarget(self, action: #selector(self.handleTap), for: .touchUpInside)
    }
    
    @objc fileprivate func handleTap()
    {
        isMenuShowing ? removeTable() : showTable()
    }
    
    fileprivate func setupUI()
    {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(imageView)
        let imageViewHeight01 = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        imageViewHeight01.priority = 1000
        
        let imageViewHeight02 = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal , toItem: self, attribute: .height, multiplier: 1, constant: 0)
        imageViewHeight02.priority = 900
        
        addConstraints([

            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8),
            imageViewHeight01,
            imageViewHeight02,
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal , toItem: self, attribute: .height, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal , toItem: self, attribute: .height, multiplier: 1, constant: 0)

            ])
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = downImage
    }
 
    fileprivate func showTable()
    {
        let tableHeight = min((CGFloat(showDatas.count) * rowHeight),maxTableHeight)
        let frame = CGRect(x: self.frame.minX , y: self.frame.maxY + menuLeavlSpace , width: self.frame.size.width, height: 0)
        table = UITableView(frame:frame)
        table?.layer.borderColor = UIColor.lightGray.cgColor
        table?.layer.borderWidth = 0.5
        table?.alpha = 0
        table?.bounces = false
        table?.delegate = self
        table?.dataSource = self
        table?.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier )
        
        self.superview?.addSubview(table!)
        UIView.animate(withDuration: duration, animations: {
            self.imageView.image = self.upImage
            self.table?.alpha = 1
            self.table?.frame.size.height = tableHeight
            
        })
        
    }
    
    fileprivate func removeTable()
    {
        table?.delegate = nil
        
        UIView.animate(withDuration: duration, animations:  {
            self.table?.frame.size.height = 0.0
            self.imageView.image = self.downImage
        })  { (bool) in
            if bool
            {
                self.table?.dataSource = nil
                self.table?.removeFromSuperview()
                self.table = nil
            }
        }
    }
    
    public func setupImage(upImage:UIImage?,downImage:UIImage?)
    {
        self.downImage = downImage
        self.upImage = upImage
    }

    
}

extension CHL_DropMenu : UITableViewDataSource , UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showDatas.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = showDatas[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choose = showDatas[indexPath.row]
        delegate?.didSelect(title: choose, index: indexPath.row)
        titleLabel.text = choose
        removeTable()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins )){
            cell.layoutMargins = .zero
        }
        
    }

}





















