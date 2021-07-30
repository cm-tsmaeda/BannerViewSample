//
//  BannerView.swift
//  BannerViewSample
//  
//  Created by maeda.tasuku on 2021/07/30
//  
//

import UIKit

class BannerView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
