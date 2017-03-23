//
//  CPReposPosterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate


protocol ReposActionProtocol {
    
    func watchReposAction()
    func starReposAction()
    func forkReposAction()
    
}

/// Repos 头部的代码库的主要信息视图
class CPReposPosterView: UIView {

    var imgV: UIImageView = UIImageView.init()
    
    var nameLabel: UILabel = UILabel.init()
    var descLabel: UILabel = UILabel.init()
    var timeLabel: UILabel = UILabel.init()
    
    var watchBtn: UIButton = UIButton.init()
    var starBtn: UIButton = UIButton.init()
    var forkBtn: UIButton = UIButton.init()


    var reposActionDelegate:ReposActionProtocol?
    var dynH:CGFloat = 0.0
    
    var repo:ObjRepos? {
        didSet{
            rpv_fillData()
        }
    }
    
    var watched:Bool?{
        didSet{
            if(watched!){
                watchBtn.setTitle("Unwatch".localized, for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)

            }else{
                watchBtn.setTitle("Watch".localized, for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)

            }
        }
    }
    
    var stared:Bool?{
        didSet{
            if(stared!){
                starBtn.setTitle("Unstar".localized, for: UIControlState())
            }else{
                starBtn.setTitle("Star".localized, for: UIControlState())
            }
        }

    }
    
    // MARK: - Init
    /// Init
    ///
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        rpv_customView()
    }
    
    convenience init(obj:ObjRepos){
        self.init(frame:CGRect.zero)
        self.repo = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - View
    func rpv_customView() {
        
        self.addSubview(self.imgV)
        self.addSubview(self.nameLabel)
        self.addSubview(self.descLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.watchBtn)
        self.addSubview(self.forkBtn)
        self.addSubview(self.starBtn)
        
        self.backgroundColor = UIColor.white
        nameLabel.textColor = UIColor.labelTitleTextColor
        nameLabel.backgroundColor = UIColor.white
        
        descLabel.textColor = UIColor.labelSubtitleTextColor
        descLabel.backgroundColor = UIColor.white
        descLabel.numberOfLines = 3;
        
        timeLabel.backgroundColor = UIColor.white
        timeLabel.textColor = UIColor.hex("#4876FF")

        
        let imgEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)
        let cornerRadius:CGFloat = 5.0
        let borderWidth:CGFloat = 0.5
        
        let btnArr = [watchBtn,starBtn,forkBtn]
        
        for btn in btnArr {
            
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets
            btn.layer.cornerRadius = cornerRadius
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.cpRedColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.cpRedColor, for: UIControlState())
            
        }
    }
    
    override func layoutSubviews() {
    
        let margin:CGFloat = 10.0
        let imgW = designBy4_7Inch(80)
        
        imgV.snp.remakeConstraints { (make) in
            make.width.height.equalTo(imgW)
            make.top.equalTo(margin+7.0)
            make.left.equalTo(margin)
        }
        
        let nameL = imgV.right+10
        let nameT = 10
        let nameH = 24
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(nameT)
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.height.equalTo(nameH)
        }
        
        var descT = nameLabel.bottom+2.0
        var descH = descLabel.requiredHeight(width:nameLabel.width)
        if descH > 47.0 {
            descH = 47.0
        }
        
        if descH < 18 {
            descT = nameLabel.bottom + 12.0
        }else if descH < 32 {
            descH = nameLabel.bottom + 8.0
        }
        
        descLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.top.equalTo(descT)
            make.height.equalTo(descH)
        }
        
        let timeT = imgV.bottom-16
        timeLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.top.equalTo(timeT)
            make.height.equalTo(21)
        }
        
        
        let top:CGFloat = max(imgV.bottom, timeLabel.bottom)+10.0
        let width = (ScreenSize.width-4*margin)/3;
        let height:CGFloat = designBy4_7Inch(30.0)
        
        let btnArr = [watchBtn,starBtn,forkBtn]
        
        for (index,button) in btnArr.enumerated() {
            let left = CGFloat.init(index) * (width+margin) + margin
            button.snp.remakeConstraints({ (make) in
                make.left.equalTo(left)
                make.top.equalTo(top)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
        }

    }
    
    // MARK: - Data
    func rpv_fillData() {
        
        rpv_settingButtons()
        
        if let avatarUrl =  repo?.owner?.avatar_url {
            imgV.kf.setImage(with: URL(string: avatarUrl)!)
        }
        
        if let username = repo!.name {
            nameLabel.text = username
        }
        
        if let cdescription = repo!.cdescription {
            descLabel.text = cdescription
        }
        
        if let created_at = repo!.created_at {
            timeLabel.text = TimeHelper.shared.readableTime(rare: created_at, prefix: "created at: ")
        }
        
        self.setNeedsLayout()
    }
    
    
    func rpv_settingButtons(){
        
        watchBtn.setImage(UIImage(named: "octicon_watch_red_20"), for: UIControlState())
        watchBtn.setTitle("Watch".localized, for: UIControlState())
        watchBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_watchAction), for: .touchUpInside)
        
        starBtn.setImage(UIImage(named: "octicon_star_red_20"), for: UIControlState())
        starBtn.setTitle("Star".localized, for: UIControlState())
        starBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_starAction), for: .touchUpInside)
        
        forkBtn.setImage(UIImage(named: "octicon_fork_red_20"), for: UIControlState())
        forkBtn.setTitle("Fork".localized, for: UIControlState())
        forkBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_forkAction), for: .touchUpInside)
    }
    
    // MARK: - Action
    func rpv_watchAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.watchReposAction()
        }
        
    }
    
    func rpv_starAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.starReposAction()
        }
        
    }
    
    func rpv_forkAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.forkReposAction()
        }
        
    }
    

}
