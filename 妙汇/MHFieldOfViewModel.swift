//
//  MHFieldOfViewModel.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/1.
//  Copyright © 2016年 韩威. All rights reserved.
//

import HandyJSON

//{
//    "resultCode": 1,
//    "resultMsg": "成功",
//    "tipsMsg": "",
//    "specialTopicList": [
//    {
//    "article_id": "441",
//    "cat_id": "5",
//    "title": "柯达全新摄像手机，手残达人也能拍美照",
//    "subtitle": "手机界的拍照神器Ektra",
//    "picture_url": "http://image.app.magicwe.com/images/201610/1477901283875729645.jpg",
//    "share_count": "0",
//    "like_count": "0",
//    "comment_count": "0",
//    "view_count": "10",
//    "image_url": "http://image.app.magicwe.com/images/201610/1477901283796304437.jpg",
//    "link_url": "http://www.miaohui.com/posts/441"
//    },
//    {
class MHSpecialTopic: HandyJSON {
    var article_id: String?
    var cat_id: String?
    var title: String?
    var subtitle: String?
    var picture_url: String?
    var share_count: String?
    var like_count: String?
    var comment_count: String?
    var view_count: String?
    var image_url: String?
    var link_url: String?
    
    required init() {}
}

class MHFieldOfViewModel: MHResponseModel {
    var specialTopicList: [MHSpecialTopic]?
    required init() {}
}



//{
//    "resultCode": 1,
//    "resultMsg": "成功",
//    "tipsMsg": "",
//    "navigator": [
//    {
//    "name": "全部",
//    "url": "mwarticletag://0",
//    "icon": "",
//    "image": null
//    },

class MHFieldOfViewCategory: HandyJSON {
    var name: String?
    var url: String?
    var icon: String?
    var image: String?
    
    required init() {}
}

class MHFieldOfViewCategoryResponse: MHResponseModel {
    var navigator: [MHFieldOfViewCategory]?
    required init() {}
}

