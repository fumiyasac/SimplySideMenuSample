//
//  PictureCell.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {

    //セル内の部品を配置
    @IBOutlet weak var parallaxImage: UIImageView!
    @IBOutlet weak var pictureTitle: UILabel!
    @IBOutlet weak var pictureCopy: UILabel!
    @IBOutlet weak var pictureDate: UILabel!

    //上下のAutoLayout制約
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //視差効果のズレを生むための定数（大きいほど視差効果が大きい）
    let imageParallaxFactor: CGFloat = 100
    
    //視差効果の計算用の変数
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    
    //CellModelに値がセットされたら各部品にその値を格納する
    var model: PictureModel! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //意図的にずらした値を視差効果の計算用の変数にそれぞれ格納する
        clipsToBounds = true
        bottomConstraint.constant -= 2 * imageParallaxFactor
        imgBackTopInitial = topConstraint.constant
        imgBackBottomInitial = bottomConstraint.constant
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //セルに配置した部品の中に値を入れる
    func updateView() {
        parallaxImage.image = UIImage(named: model.backimage)
        pictureTitle.text = model.title
        pictureCopy.text = model.kcpy
        pictureDate.text = model.datestr
    }
    
    //背景画像にかけられているAutoLayoutの制約を再計算して制約をかけ直す
    func setBackgroundOffset(_ offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        topConstraint.constant = imgBackTopInitial - pixelOffset
        bottomConstraint.constant = imgBackBottomInitial + pixelOffset
    }
    
}
