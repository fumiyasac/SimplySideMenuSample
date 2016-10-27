//
//  Settings.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

//コンテナビューの開閉状態の識別用タグの値
enum ContainerSetting {
    case opened
    case closed
}

//コンテンツのテーブルビューのタグの値
enum ContentsScrollDirection {
    case upper
    case lower
}

//ボタンに表示する文言のリスト
struct ScrollButtonList {
    static let buttonList: [String] = [
        "Breakfast Menu1",
        "Breakfast Menu2",
        "Breakfast Menu3",
        "Breakfast Menu4",
        "Breakfast Menu5",
        "Breakfast Menu6",
        "Breakfast Menu7",
        "Breakfast Menu8",
        "Breakfast Menu9"
    ]
}

//スライドメニューの位置
struct SlideMenuSetting {
    static let movingLabelY = 38
    static let movingLabelH = 2
}
