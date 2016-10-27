//
//  MHGoods.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import HandyJSON

/*
 {
 "type": "product",
 "url": "1237",
 "pic": "http://ecshop.magicwe.com/images/201610/1476080913307961796.JPG",
 "protocol": "mwgoods://1237"
 },
 */
/// 首页轮播图
class MHBanner: HandyJSON{
    var type: String?
    var url: String?
    var pic: String?
    var protocol_s: String?
    
    func mapping(mapper: HelpingMapper) {
        // 指定 protocol_s 字段用 "protocol" 去解析
        mapper.specify(property: &protocol_s, name: "protocol")
        
//        // 指定 parent 字段用这个方法去解析
//        mapper.specify(property: &parent) { (rawString) -> (String, String) in
//            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
//            return (parentNames[0], parentNames[1])
//        }
    }
    
    required init() {}
}

/*
 {
 "name": "热卖",
 "url": "mwgoodstag://hot",
 "icon": "http://image.app.magicwe.com/images/201606/1464762975951452271.png",
 "image": "http://image.app.magicwe.com/images/201609/1473674109107929859.png"
 },
 */
/// 首页第二栏内容
class MHNavigator: HandyJSON {
    var name: String?
    var url: String?
    var icon: String?
    var image: String?
    
    required init() {}
}

/*
{
    "article_id": "431",
    "cat_id": "5",
    "title": "Boys On Wheels 家居，给你原始的味道",
    "subtitle": "一秒回到“原始社会”",
    "file_url": "images/201610/1476671875632710286.jpg",
    "picture_url": "images/201610/1476671875332862602.jpg",
    "share_count": "0",
    "like_count": "1",
    "comment_count": "0",
    "view_count": "27",
    "link_url": "http://www.miaohui.com/posts/431"
},
*/
///首页 ‘视野’ 栏目
class MHArticle: HandyJSON {
    var article_id: String?
    var cat_id: String?
    var title: String?
    var subtitle: String?
    var file_url: String?
    var picture_url: String?
    var share_count: String?
    var like_count: String?
    var comment_count: String?
    var view_count: String?
    var link_url: String?
    
    required init() {}
}

/*
{
    "ad_name": "无门槛现金券",
    "ad_title": "每日优惠，用心等候",
    "ad_link": "http://www.miaohui.com/u/turnplate?aid=20&$share$=false",
    "ad_code": "http://image.app.magicwe.com/data/afficheimg/1467799623958226534.png",
    "server_time": "1476754311",
    "start_time": "1476671400",
    "end_time": "1476757800",
    "link_goods_id": "0",
    "shop_price": null,
    "promote_price": null,
    "promote_start_date": null,
    "promote_end_date": null
}
 */
/// 首页第四栏广告栏
class MHPromotion: HandyJSON {
    var ad_name: String?
    var ad_title: String?
    var ad_link: String?
    var ad_code: String?
    var server_time: String?
    var start_time: String?
    var end_time: String?
    var link_goods_id: String?
    var shop_price: String?
    var promote_price: String?
    var promote_start_date: String?
    var promote_end_date: String?
    
    required init() {}
}

/// 商品列表
class MHGoods: HandyJSON{
    var goods_id: String?
    var cat_id: String?
    var goods_name: String?
    var goods_brief: String?
    var market_price: String?
    var promote_price: String?
    var promote_start_date: String?
    var promote_end_date: String?
    var goods_thumb: String?
    var goods_img: String?
    var original_img: String?
    var list_img: String?
    var detail_img: String?
    var panorama_path: String?
    var panorama_size: String?
    var view_uuid: String?
    var share_count: String?
    var like_count: String?
    var hate_count: String?
    var click_count: String?
    var goods_selling_point: String?
    var shop_price: String?
    var nav_cat_id: String?
    var miaohui_price: String?
    var attitude: String?
    
    required init() {}
}


class MHHomeDataModel: HandyJSON {
    var banner: [MHBanner]?
    var navigator: [MHNavigator]?
    var articles: [MHArticle]?
    var promotions: [MHPromotion]?
    var goods: [MHGoods]?
    
    required init() {}
}

//{
//    "resultCode": 1,
//    "resultMsg": "成功",
//    "tipsMsg": "",
//    "list": {
//        "banner": [
class MHHomeData: MHResponseModel {
    var list: MHHomeDataModel?
    
    required init() {}
}


//{
//    "resultCode": 1,
//    "resultMsg": "成功",
//    "tipsMsg": "",
//    "navigation": [

class MHCategory: MHResponseModel {
    var navigation: [MHNavigator]?
    
    required init() {}
}







