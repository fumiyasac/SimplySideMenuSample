//
//  ViewController.swift
//  SimplySideMenuSample
//
//  Created by 酒井文也 on 2016/10/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    //コンテンツを覆うボタン
    @IBOutlet weak var draggableButton: UIButton!
    
    //メインコンテンツ用のコンテナビュー
    @IBOutlet weak var mainContentsContainer: UIView!
    
    //サイドメニュー用のコンテナビュー
    @IBOutlet weak var sideMenuContainer: UIView!
    
    //コンテナの開閉状態
    var statusSetting: ContainerSetting = .closed
    
    //左隅部分のGestureRecognizer（コンテンツが閉じた状態で仕込まれる）
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    //このViewControllerのタッチイベント開始時のx座標（コンテンツが開いた状態で仕込まれる）
    var touchBeganPositionX: CGFloat!
    
    //タップジェスチャー時に別のタップが呼ばれないようにする
    var tapOnceFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //透明ボタンの初期状態を決定
        draggableButton.backgroundColor = UIColor.black
        draggableButton.alpha = 0
        draggableButton.isUserInteractionEnabled = false

        //サイドメニュー用のコンテナビューの初期状態を決定
        sideMenuContainer.alpha = 0
        sideMenuContainer.isUserInteractionEnabled = false

        //左隅部分のGestureRecognizerを作成する（デリゲートの設定と検知位置を決める）
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ViewController.edgeTapGesture(sender:)))
        edgeGesture.delegate = self
        edgeGesture.edges = .left

        //初期状態では左隅部分のGestureRecognizerを有効にしておく
        mainContentsContainer.addGestureRecognizer(edgeGesture)
    }

    //※サイドメニューが閉じた状態：左隅のドラッグを行ってコンテンツを開く際の処理
    func edgeTapGesture(sender: UIScreenEdgePanGestureRecognizer) {

        //サイドメニューのタッチイベントを有効にする
        sideMenuContainer.isUserInteractionEnabled = true
        
        //メインコンテンツのタッチイベントを無効にする
        mainContentsContainer.isUserInteractionEnabled = false
        
        //移動量を取得する
        let move: CGPoint = sender.translation(in: mainContentsContainer)
        
        //メインコンテンツと透明ボタンのx座標に移動量を加算する
        draggableButton.frame.origin.x += move.x
        mainContentsContainer.frame.origin.x += move.x
        
        //Debug.
        //print("サイドコンテンツが閉じた状態でのドラッグの加算量:\(move.x)")
        
        //サイドメニューとボタンのアルファ値を変更する
        sideMenuContainer.alpha = mainContentsContainer.frame.origin.x / 240
        draggableButton.alpha = mainContentsContainer.frame.origin.x / 240 * 0.36

        //メインコンテンツのx座標が0〜240の間に収まるように補正
        if mainContentsContainer.frame.origin.x > 240 {
            mainContentsContainer.frame.origin.x = 240
            draggableButton.frame.origin.x = 240
        } else if mainContentsContainer.frame.origin.x < 0 {
            mainContentsContainer.frame.origin.x = 0
            draggableButton.frame.origin.x = 0
        }

        //ドラッグ終了時の処理
        /**
         * 境界値(x座標:160)のところで開閉状態を決める
         * ボタンエリアが開いた時の位置から変わらない時(x座標:240)または境界値より前ではコンテンツを閉じる
         */
        if sender.state == UIGestureRecognizerState.ended {
            if mainContentsContainer.frame.origin.x < 160 {
                changeContainerSetting(status: .closed)
            } else {
                changeContainerSetting(status: .opened)
            }
        }
        
        //移動量をリセットする
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainContentsContainer.frame = CGRect(
            x: mainContentsContainer.frame.origin.x,
            y: mainContentsContainer.frame.origin.y,
            width: mainContentsContainer.frame.width,
            height: mainContentsContainer.frame.height
        )
        sideMenuContainer.frame = CGRect(
            x: sideMenuContainer.frame.origin.x,
            y: sideMenuContainer.frame.origin.y,
            width: sideMenuContainer.frame.width,
            height: sideMenuContainer.frame.height
        )
        draggableButton.frame = CGRect(
            x: draggableButton.frame.origin.x,
            y: draggableButton.frame.origin.y,
            width: draggableButton.frame.width,
            height: draggableButton.frame.height
        )
    }

    //コンテナの開閉状態を制御する
    func changeContainerSetting(status: ContainerSetting) {
        
        //メニューが閉じている状態で押された → コンテンツを開く
        if status == .opened {
            
            statusSetting = .opened
            UIView.animate(withDuration: 0.16, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                //メインコンテンツを移動させてサイドメニューを表示させる
                self.mainContentsContainer.frame = CGRect(
                    x: 240,
                    y: self.mainContentsContainer.frame.origin.y,
                    width: self.mainContentsContainer.frame.width,
                    height: self.mainContentsContainer.frame.height
                )
                self.draggableButton.frame = CGRect(
                    x: 240,
                    y: self.draggableButton.frame.origin.y,
                    width: self.draggableButton.frame.width,
                    height: self.draggableButton.frame.height
                )
                
                //アルファを設定する
                self.draggableButton.alpha = 0.36
                self.sideMenuContainer.alpha = 1
                
                }, completion: { finished in

                    //サイドメニューはタッチイベントを有効にする
                    self.sideMenuContainer.isUserInteractionEnabled = true
                    
                    //メインコンテンツはタッチイベントを無効にする
                    self.mainContentsContainer.isUserInteractionEnabled = false
                }
            )
            
        //メニューが開いている状態で押された → コンテンツを閉じる
        } else {
            
            statusSetting = .closed
            UIView.animate(withDuration: 0.16, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                //メインコンテンツを移動させてサイドメニューを閉じる
                self.mainContentsContainer.frame = CGRect(
                    x: 0,
                    y: self.mainContentsContainer.frame.origin.y,
                    width: self.mainContentsContainer.frame.width,
                    height: self.mainContentsContainer.frame.height
                )
                self.draggableButton.frame = CGRect(
                    x: 0,
                    y: self.draggableButton.frame.origin.y,
                    width: self.draggableButton.frame.width,
                    height: self.draggableButton.frame.height
                )

                //アルファを設定する
                self.draggableButton.alpha = 0
                self.sideMenuContainer.alpha = 0

                }, completion: { finished in
                    
                    //サイドメニューはタッチイベントを無効にする
                    self.sideMenuContainer.isUserInteractionEnabled = false
                    
                    //メインコンテンツはタッチイベントを有効にする
                    self.mainContentsContainer.isUserInteractionEnabled = true
                }
            )
        }
    }

    //※サイドメニューが開いた状態：タッチイベントの開始時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        //サイドメニューが開いた際にタッチイベント開始位置のx座標を取得してメンバ変数に格納する
        let touchEvent = touches.first!
        
        //タッチイベント開始時のself.viewのx座標を取得する
        let beginPosition = touchEvent.previousLocation(in: self.view)
        touchBeganPositionX = beginPosition.x

        //Debug.
        //print("サイドコンテンツが開いた状態でのドラッグ開始時のx座標:\(touchBeganPositionX)")
    }
    
    //※サイドメニューが開いた状態：タッチイベントの実行中の処理
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        //タッチイベント開始位置のx座標がサイドナビゲーション幅より大きい場合
        // → メインコンテンツと透明ボタンをドラッグで動かすことができるようにする
        if statusSetting == .opened && touchBeganPositionX >= 240 {
            
            let touchEvent = touches.first!
            
            //ドラッグ前の座標
            let preDx = touchEvent.previousLocation(in: self.view).x
            
            //ドラッグ後の座標
            let newDx = touchEvent.location(in: self.view).x
            
            //ドラッグしたx座標の移動距離
            let dx = newDx - preDx
            
            //画像のフレーム
            var viewFrame: CGRect = draggableButton.frame
            
            //移動分を反映させる
            viewFrame.origin.x += dx
            mainContentsContainer.frame = viewFrame
            draggableButton.frame = viewFrame
            
            //Debug.
            //print("サイドコンテンツが開いた状態でのドラッグ中のx座標:\(viewFrame.origin.x)")
            
            //メインコンテンツのx座標が0〜240の間に収まるように補正
            if mainContentsContainer.frame.origin.x > 240 {
                mainContentsContainer.frame.origin.x = 240
                draggableButton.frame.origin.x = 240
            } else if mainContentsContainer.frame.origin.x < 0 {
                mainContentsContainer.frame.origin.x = 0
                draggableButton.frame.origin.x = 0
            }
            
            //サイドメニューとボタンのアルファ値を変更する
            sideMenuContainer.alpha = mainContentsContainer.frame.origin.x / 240
            draggableButton.alpha = mainContentsContainer.frame.origin.x / 240 * 0.36
        }

    }
    
    //※サイドメニューが開いた状態：タッチイベントの終了時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //タッチイベント終了時はメインコンテンツと透明ボタンの位置で開くか閉じるかを決める
        /**
         * 境界値(x座標:160)のところで開閉状態を決める
         * ボタンエリアが開いた時の位置から変わらない時(x座標:240)または境界値より前ではコンテンツを閉じる
         */
        if touchBeganPositionX >= 240 && (mainContentsContainer.frame.origin.x == 240 || mainContentsContainer.frame.origin.x < 160) {
            changeContainerSetting(status: .closed)
        } else if touchBeganPositionX >= 240 && mainContentsContainer.frame.origin.x >= 160 {
            changeContainerSetting(status: .opened)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

