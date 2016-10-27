//
//  PictureModel.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

//PictureCellに値を渡すモデル
class PictureModel {
    
    //変数
    var backimage: String
    var title: String
    var kcpy: String
    var datestr: String
    
    //初期化
    init(backimage: String, title: String, kcpy: String, datestr: String) {
        self.backimage = backimage
        self.title = title
        self.kcpy = kcpy
        self.datestr = datestr
    }
    
}
