//
//  CPShowcaseInfoView.swift
//  BeeFun
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPShowcaseInfoView: UIView {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var descLabel: UILabel!

    
    var showcase:ObjShowcase? {
        didSet{
            siv_fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        siv_customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(obj:ObjShowcase){
        super.init(frame:CGRect.zero)
        self.showcase = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func siv_customView() {
        
        self.backgroundColor = UIColor.hex("#e8e8e8", alpha: 1.0)
        imgV.layer.cornerRadius = imgV.width/2
        imgV.layer.masksToBounds = true
        
        descLabel.textColor = UIColor.darkGray
        
    }
    
    
    func siv_fillData() {
        
        let url = showcase!.image_url!
        imgV.kf.setImage(with: URL(string: url)!)
        descLabel.text = showcase!.cdescription!
        
    }

}
