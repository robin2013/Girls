//
//  GQiuShiHomeViewController.swift
//  Girls
//
//  Created by 张如泉 on 16/3/24.
//  Copyright © 2016年 quange. All rights reserved.
//

import UIKit
import SVPullToRefresh
import QGCollectionMenu

class GQiuShiHomeViewController: UIViewController,QGCollectionMenuDataSource,QGCollectionMenuDelegate {
    let titleArray : NSArray = [ "最新","纯图","最热"]
    var viewModels : NSMutableArray = []
    @IBOutlet weak var collectionMenu: QGCollectionMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.collectionMenu.dataSource = self;
        self.collectionMenu.delegate = self;
        self.collectionMenu.reload();
       
        viewModels.addObject(GQiuBaiViewModel(dataType: .lastest)!)
        viewModels.addObject(GQiuBaiViewModel(dataType: .onlyImage)!)
        viewModels.addObject(GQiuBaiViewModel(dataType: .hotest)!)
        self.title = "笑话"
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        collectionMenu.subVCCollectionContentInsetUpdate()
    //    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func menumTitles() -> [AnyObject]!
    {
        return titleArray as [AnyObject]
    }
    //
    func subVCClassStrsForStoryBoard() -> [AnyObject]!
    {
        return ["GQiuShiSubViewController", "GQiuShiSubViewController", "GQiuShiSubViewController"]
        
    }
    //
    func subVCClassStrsForCode() -> [AnyObject]!
    {
        return []
    }
    
    func updateSubVCWithIndex(index: Int)
    {
        let subs: [(GQiuShiSubViewController)] = self.childViewControllers as! [(GQiuShiSubViewController)];
        for vc in subs {
            if(vc.view.tag == index)
            {
                if(vc.viewModel != viewModels[index] as? GQiuBaiViewModel)
                {
                    vc.viewModel = viewModels[index] as? GQiuBaiViewModel
                    vc.tableView.reloadData()
                }
                
                if vc.viewModel?.numOfItems()==0
                {
                    vc.tableView.triggerPullToRefresh()
                }
                break
                
            }
        }
    }
    
    
}
