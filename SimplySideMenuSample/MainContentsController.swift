//
//  MainContentsController.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class MainContentsController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {

    //パララックス用のテーブルビュー
    @IBOutlet weak var parallaxTableView: UITableView!

    //スクロールと位置補正が可能なボタンを入れるスクロールビュー
    @IBOutlet weak var multiButtonScrollView: UIScrollView!

    //ボタン部分の上制約
    @IBOutlet weak var topMenuConstraint: NSLayoutConstraint!

    //メニュー用ハンバーガーボタン
    var menuButton: UIBarButtonItem!

    //セルに表示するデータモデルの変数 ※PictureModel.swift参照
    var models: [PictureModel] = []
    
    //テーブルビューのスクロールの開始位置を格納する変数
    fileprivate var scrollBeginingPoint: CGPoint!
    
    //スクロールビュー内のボタンを一度だけ生成するフラグ
    fileprivate var layoutOnceFlag: Bool = false
    
    //スクロール内の動くラベル
    fileprivate let movingLabel = UILabel()

    //ボタンスクロール時の移動量
    fileprivate var scrollButtonOffsetX: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //StatusBarの背景を設定
        let statusBar = UIView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBar.backgroundColor = UIColor.white
        view.addSubview(statusBar)
        
        //UINavigationControllerのデリゲート
        navigationController?.delegate = self
        
        //ナビゲーションと色設定
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        //タイトルテキスト用の色設定
        let attrs = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 17)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationItem.title = "🌽 BreakFast List 🍞"
        
        //メニューボタンを設置
        menuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(MainContentsController.menuButtonTapped(button:)))
        menuButton.setTitleTextAttributes(
            [
                NSForegroundColorAttributeName : UIColor.gray,
                NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 30)!
            ], for: .normal)
        navigationItem.leftBarButtonItem = menuButton
        
        //UITableViewのデリゲート・データソース
        parallaxTableView.delegate = self
        parallaxTableView.dataSource = self
        parallaxTableView.rowHeight = 210
        
        //Xibのクラスを読み込む宣言を行う
        let nibTableView: UINib = UINib(nibName: "PictureCell", bundle: nil)
        parallaxTableView.register(nibTableView, forCellReuseIdentifier: "PictureCell")
        
        //サンプルデータをPictureModelに投入する
        initTableViewData()
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //動的に配置する見た目要素は一度だけ実行する
        if layoutOnceFlag == false {
            
            //コンテンツ用のScrollViewを初期化
            initScrollViewDefinition()
            
            //スクロールビュー内のサイズを決定する
            multiButtonScrollView.contentSize = CGSize(
                width: CGFloat(Int(multiButtonScrollView.frame.width / 3) * ScrollButtonList.buttonList.count),
                height: multiButtonScrollView.frame.height
            )
            
            //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
            for i in 0...(ScrollButtonList.buttonList.count - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                let buttonElement: UIButton! = UIButton()
                multiButtonScrollView.addSubview(buttonElement)
                
                buttonElement.frame = CGRect(
                    x: CGFloat(Int(multiButtonScrollView.frame.width) / 3 * i),
                    y: 0,
                    width: multiButtonScrollView.frame.width / 3,
                    height: multiButtonScrollView.frame.height
                )
                buttonElement.backgroundColor = UIColor.clear
                buttonElement.setTitle(ScrollButtonList.buttonList[i], for: UIControlState())
                buttonElement.setTitleColor(UIColor.gray, for: UIControlState())
                buttonElement.titleLabel!.font = UIFont(name: "Georgia-Bold", size: 11)!
                buttonElement.tag = i
                buttonElement.addTarget(self, action: #selector(MainContentsController.scrollButtonTapped(button:)), for: .touchUpInside)
                
            }
            
            //動くラベルの配置
            multiButtonScrollView.addSubview(movingLabel)
            multiButtonScrollView.bringSubview(toFront: movingLabel)
            movingLabel.frame = CGRect(
                x: 0,
                y: SlideMenuSetting.movingLabelY,
                width: Int(self.view.frame.width / 3),
                height: SlideMenuSetting.movingLabelH
            )
            movingLabel.backgroundColor = UIColor.orange
            
            //一度だけ実行するフラグを有効化
            layoutOnceFlag = true
        }
        
    }
    
    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //（重要）MainContentsControllerの「Adjust Scroll View Insets」のチェックを外しておく
        //スクロールビュー内の各プロパティ値を設定する
        multiButtonScrollView.isPagingEnabled = false
        multiButtonScrollView.isScrollEnabled = true
        multiButtonScrollView.isDirectionalLockEnabled = false
        multiButtonScrollView.showsHorizontalScrollIndicator = false
        multiButtonScrollView.showsVerticalScrollIndicator = false
        multiButtonScrollView.bounces = false
        multiButtonScrollView.scrollsToTop = false
    }
    
    //テーブルビューで表示するデータを注入する
    fileprivate func initTableViewData() {
        models.append(
            PictureModel(
                backimage: "image1.jpg",
                title: "Cafe and Pan Cake Style",
                kcpy: "Popular and Pretty style breakfast plate.",
                datestr: "2016/10/27"
            )
        )
        models.append(
            PictureModel(
                backimage: "image2.jpg",
                title: "Fruits and Granora Style",
                kcpy: "Simple and useful for busy morning time.",
                datestr: "2016/10/27"
            )
        )
        models.append(
            PictureModel(
                backimage: "image3.jpg",
                title: "Baglesand with Loast Beef Style",
                kcpy: "High volume and very powerful meal.",
                datestr: "2016/10/27"
            )
        )
        models.append(
            PictureModel(
                backimage: "image4.jpg",
                title: "Sandwitch and Salad Style",
                kcpy: "The elegant breakfast not inferior to cafe.",
                datestr: "2016/10/27"
            )
        )
        models.append(
            PictureModel(
                backimage: "image5.jpg",
                title: "Typical Japanese Style",
                kcpy: "Rice, Miso soup and grilled fish. This is 'wa'.",
                datestr: "2016/10/27"
            )
        )
        models.append(
            PictureModel(
                backimage: "image6.jpg",
                title: "Home-made Breakfast Style",
                kcpy: "Breakfast timeless and be used to eating.",
                datestr: "2016/10/27"
            )
        )
    }
    
    //メニューボタンタップ時のメソッド
    func menuButtonTapped(button: UIButton) {
        let vc = self.parent?.parent as! ViewController
        vc.changeContainerSetting(status: .opened)
    }

    //ボタンをタップした際に行われる処理
    func scrollButtonTapped(button: UIButton) {
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveToCurrentButtonLabelButtonTapped(page: page)
        moveFormNowButtonContentsScrollView(page: page)
    }

    //ボタンタップ時に動くラベルをスライドさせる
    fileprivate func moveToCurrentButtonLabelButtonTapped(page: Int) {
        
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            
            self.movingLabel.frame = CGRect(
                x: Int(self.view.frame.width) / 3 * page,
                y: SlideMenuSetting.movingLabelY,
                width: Int(self.view.frame.width) / 3,
                height: SlideMenuSetting.movingLabelH
            )
        }, completion: nil)
    }

    //ボタンのスクロールビューをスライドさせる
    fileprivate func moveFormNowButtonContentsScrollView(page: Int) {
        
        //Case1:ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (ScrollButtonList.buttonList.count - 1) {
            
            scrollButtonOffsetX = Int(multiButtonScrollView.frame.width) / 3 * (page - 1)
            
        //Case2:一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3:一番最後のpage番号のときの移動量
        } else if page == (ScrollButtonList.buttonList.count - 1) {
            
            scrollButtonOffsetX = Int(multiButtonScrollView.frame.width) * (ScrollButtonList.buttonList.count / 3 - 1)
        }
        
        UIView.animate(withDuration: 0.26, delay: 0, options: [], animations: {
            self.multiButtonScrollView.contentOffset = CGPoint(
                x: self.scrollButtonOffsetX,
                y: 0
            )
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* UITableViewDataSource */
    
    //Cellの総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as? PictureCell
        cell?.model = modelAtIndexPath(indexPath)
        
        //セルのアクセサリタイプの設定
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

    //indexPath.rowの値に合致するCellModelの値を選択する
    fileprivate func modelAtIndexPath(_ indexPath: IndexPath) -> PictureModel {
        return models[indexPath.row % models.count]
    }

    /* UIScrollViewDelegate */

    //スクロール開始位置を取得
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginingPoint = scrollView.contentOffset
    }
    
    //スクロールが検知された時に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //パララックスをするテーブルビューの場合
        if scrollView == parallaxTableView {
            
            //画面に表示されているセルの画像のオフセット値を変更する
            for indexPath in parallaxTableView.indexPathsForVisibleRows! {
                setCellImageOffset(parallaxTableView.cellForRow(at: indexPath) as! PictureCell, indexPath: indexPath)
            }
            
            //スクロール終了時のy座標を取得する
            let currentPoint = scrollView.contentOffset
            
            //下方向のスクロールを行った場合の処理
            if scrollBeginingPoint.y < currentPoint.y {
                
                //自作メニューを隠して、変化量が40以上であればナビゲーションバーも一緒に隠す
                topMenuConstraint.constant = -40
                UIView.animate(withDuration: 0.26, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    //変更したAutoLayoutのConstant値を適用する
                    self.view.layoutIfNeeded()
                    }, completion: { finished in
                })

                if currentPoint.y - self.scrollBeginingPoint.y > 40 {
                    hideNavigationFromChildView(direction: .lower)
                }
                
            //上方向のスクロールを行った場合の処理
            } else {
                
                //ナビゲーションバーを表示して、変化量が40以上であれば自作メニューも一緒に表示
                hideNavigationFromChildView(direction: .upper)
                
                if scrollBeginingPoint.y - currentPoint.y > 40 {
                    
                    topMenuConstraint.constant = 0
                    UIView.animate(withDuration: 0.26, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        //変更したAutoLayoutのConstant値を適用する
                        self.view.layoutIfNeeded()
                        }, completion: { finished in
                    })
                }
                
            }
        }
        
    }

    //NavigationBarを隠すメソッド
    func hideNavigationFromChildView(direction: ContentsScrollDirection) {
        if direction == .lower {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //まだ表示されていないセルに対しても同様の効果をつける
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let imageCell = cell as! PictureCell
        setCellImageOffset(imageCell, indexPath: indexPath)
    }
    
    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    fileprivate func setCellImageOffset(_ cell: PictureCell, indexPath: IndexPath) {
        
        let cellFrame = parallaxTableView.rectForRow(at: indexPath)
        let cellFrameInTable = parallaxTableView.convert(cellFrame, to: parallaxTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = parallaxTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        
        cell.setBackgroundOffset(cellOffsetFactor)
    }

    
    
}
