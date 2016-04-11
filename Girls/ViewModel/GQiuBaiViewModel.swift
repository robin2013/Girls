//
//  GQiuBaiViewModel.swift
//  Girls
//
//  Created by 张如泉 on 16/3/29.
//  Copyright © 2016年 quange. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa
enum GQiuBaiType {
    case lastest
    case onlyImage
    case hotest
}

class GQiuBaiViewModel: RVMViewModel {
    var qiubaiModels :NSMutableArray = []
    var qiubaiModelsSet : NSMutableSet = NSMutableSet(array:[])
    var pageIndex = 1
    
    let pageSize : Int = 30
    
    
    var type:GQiuBaiType = .lastest
    
    init?(dataType:GQiuBaiType){
        super.init()
        type = dataType
    }
    
    override init() {
        super.init()
        self.qiubaiModels = []
    }
    
    func fetchQiuBaiData(more: Bool)->RACSignal{
        
        if !more
        {
            pageIndex = 1
        }
        return GAPIManager.sharedInstance.fetchQiuBai(pageIndex,type: type).map({ (result) -> AnyObject! in
            if !more {
                self.qiubaiModels.removeAllObjects()
                self.qiubaiModels.removeAllObjects()
                self.qiubaiModelsSet.removeAllObjects()
            }
           
            var addedModel = false
            for model in result as! NSArray
            {
                let src =  model as! GQiuBaiModel
                if !self.qiubaiModelsSet.containsObject((src.modelId?.stringValue)!)
                {
                    self.qiubaiModelsSet.addObject((src.modelId?.stringValue)!)
                    self.qiubaiModels.addObject(src)
                    addedModel = true
                }
            }
            
            if addedModel
            {
                self.pageIndex++
            }
            NSLog("%d", self.qiubaiModels.count)
            
            return result
        })
        
    }
    
    func numOfItems()->Int{
        return (qiubaiModels.count)
    }
    
    func contentOfRow(row:Int)->String{
        let model = qiubaiModels[row] as! GQiuBaiModel
        return model.content!
    }
    
    func typeOfRow(row:Int)->String
    {
        let model = qiubaiModels[row] as! GQiuBaiModel
        return model.format!
    }
    
    func imageUrlOfRow(row:Int)->String
    {
        let model = qiubaiModels[row] as! GQiuBaiModel
        if model.format == "image"
        {
            let imageId = model.modelId!.stringValue as NSString
            let prefiximageId = imageId.substringToIndex(imageId.length - 4)
            //imagURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/small/\(model.image)"
           
            let image = model.image! as NSString
            let url = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/medium/\(image)"

            return url
        } else if model.format == "video"
        {
            return model.pic_url!
        }
        
        
        return ""
    }
    
    func imageHeightOfRow(row:Int)->CGFloat
    {
        let model = qiubaiModels[row] as! GQiuBaiModel
        if model.format == "image"
        {
            let size = model.imageSize! as NSDictionary
            let sizeInfo = size["m"] as! NSArray
            let hw = sizeInfo.objectAtIndex(1).floatValue/sizeInfo.objectAtIndex(0).floatValue
            
            let h = (UIScreen.mainScreen().bounds.width - 16.0) * CGFloat(hw)
            return h
        } else if model.format == "video"
        {
            let h = UIScreen.mainScreen().bounds.width - 16.0
            return h
        }

        return 0
    }
    
    func userIcon(row:Int)->String
    {
        let model = qiubaiModels[row] as! GQiuBaiModel
        if model.user == nil
        {
            return ""
        }
        
        let userInfor = model.user! as NSDictionary
        let icon  = userInfor["icon"] as! NSString
    
        let idNumber = userInfor["id"] as? NSNumber
            let userId = idNumber!.stringValue as NSString
            let prefixUserId = userId.substringToIndex(userId.length - 4)
            
            let userImageURL = "http://pic.qiushibaike.com/system/avtnew/\(prefixUserId)/\(userId)/medium/\(icon)"
            
            return userImageURL
            
        

        
    }
    
    func userNickName(row:Int)->String
    {
        let model = qiubaiModels[row] as! GQiuBaiModel
        let userInfor = model.user! as NSDictionary
        
        return userInfor["login"] as! String
    }
    
    
}
