//
//  MatchColumnTableView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 11/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MatchColumnTableView: UIView,LPRTableViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    var mRightSideTableView      = LPRTableView()
    var optionsArray = NSMutableArray()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
      

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setCurrentOptionsArray(_option:NSMutableArray)
    {
        optionsArray = _option
        
        mRightSideTableView.frame = CGRectMake( 0, 0 , self.frame.size.width, self.frame.size.height)
        self.addSubview(mRightSideTableView)
        mRightSideTableView.delegate = self
        mRightSideTableView.dataSource = self
        mRightSideTableView.registerClass(MatchColumnCell.self, forCellReuseIdentifier: "cell")
        
        mRightSideTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:MatchColumnCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! MatchColumnCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.setOptionDetails(optionsArray.objectAtIndex(indexPath.row))
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {

        let stringToMove = optionsArray.objectAtIndex(sourceIndexPath.row);
        
        optionsArray.removeObjectAtIndex(sourceIndexPath.row);
        
        optionsArray.insertObject(stringToMove, atIndex:destinationIndexPath.row);
    }
    
}