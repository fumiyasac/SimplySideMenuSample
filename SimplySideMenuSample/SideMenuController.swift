//
//  SideMenuController.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //メニューのテーブルビュー
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableViewのデリゲート・データソース
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = 60
        menuTableView.sectionHeaderHeight = 48
        
        //Xibのクラスを読み込む宣言を行う
        let nibTableView: UINib = UINib(nibName: "MenuCell", bundle: nil)
        menuTableView.register(nibTableView, forCellReuseIdentifier: "MenuCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* UITableViewDelegate */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //ヘッダー用の差し込むViewを作成する
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.white
        
        //ヘッダーに表示するラベルを作成する
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 20)
        label.text = "Menu"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.white
        label.font = UIFont(name: "Georgia-Bold", size: 15)!
        headerView.addSubview(label)

        return headerView
    }
    
    
    //Cellの総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell

        cell?.menuTitle.text = "☆ Menu Title\(indexPath.row + 1)"
        cell?.menuCopy.text = "This is Sample of Menu\(indexPath.row + 1)."
        
        //セルのアクセサリタイプの設定
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

}
