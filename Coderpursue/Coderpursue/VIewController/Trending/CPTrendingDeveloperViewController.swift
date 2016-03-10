//
//  CPTrendingDeveloperViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper
import SwiftDate

class CPTrendingDeveloperViewController: CPBaseViewController {

    @IBOutlet weak var developerInfoV: CPDeveloperInfoView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var developer:ObjUser?
    var devInfoArr = [[String:String]]()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dvc_customView()
        dvc_setupTableView()
        dvc_updateViewContent()
        dvc_getUserinfoRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        
    }
    
    func dvc_customView(){
        
        if let username = developer!.name {
            self.title = username
        }else{
            self.title = developer!.login!
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        
        
    }
    
    func dvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading ...", forState: .Refreshing)
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
    }
    
    func dvc_getUserinfoRequest(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let username = developer!.login!

        Provider.sharedProvider.request(.UserInfo(username:username) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(try response.mapJSON() ) {
                        self.developer = result
                        self.dvc_updateViewContent()
                        
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
        
    }
    
    func dvc_updateViewContent() {
        
        if(developer==nil){
            return
        }
        if let username = developer!.name {
            self.title = username
        }else{
            self.title = developer!.login!
        }
        
        devInfoArr.removeAll()
        
        if let joinTime:String = developer!.created_at {
            let ind = joinTime.startIndex.advancedBy(10)
            let subStr = joinTime.substringToIndex(ind)
            let join = "Joined on "+subStr
            let joinDic:[String:String] = ["img":"octicon_time_25","desc":join,"discolsure":"false"]
            devInfoArr.append(joinDic)
        }
        
        if let location:String = developer!.location {
            let locDic:[String:String] = ["img":"octicon_loc_25","desc":location,"discolsure":"false"]
            devInfoArr.append(locDic)
        }
        
        if let company = developer!.company {
            let companyDic:Dictionary = ["img":"octicon_org_25","desc":company,"discolsure":"false"]
            devInfoArr.append(companyDic)
        }
        
        developerInfoV.developer = developer
        self.tableView.reloadData()
    }

}

extension CPTrendingDeveloperViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return devInfoArr.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cellId = "CPDevUserInfoCellIdentifier"

        if (indexPath.section == 0){
            
            var cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPDevUserInfoCell
            if cell == nil {
                cell = (CPDevUserInfoCell.cellFromNibNamed("CPDevUserInfoCell") as! CPDevUserInfoCell)
            }
            
            //handle line in cell
            if row == 1 {
                cell!.topline = true
            }
            
            if (row == devInfoArr.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            cell!.duic_fillData(devInfoArr[row])
            
            return cell!;
        }
        
        var cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPDevUserInfoCell
        if cell == nil {
            cell = (CPDevUserInfoCell.cellFromNibNamed("CPDevUserInfoCell") as! CPDevUserInfoCell)
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == 1) {
            cell!.fullline = true
        }
        
        return cell!;
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0){
            return nil
        }
        let view = UIView.init(frame: CGRectMake(0, 0, self.view.width, 10))
        view.backgroundColor = UIColor.viewBackgroundColor()
 
        return view
    }
    
}

extension CPTrendingDeveloperViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0){
            return 0
        }
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //repos_url
    }
    
}

