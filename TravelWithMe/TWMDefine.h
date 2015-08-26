//
//  TWMDefine.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/19.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWMDefine : NSObject

/*
 * NSNotification 定義
 */
#pragma mark - NSNotification

#define PUBLISH_DONE_NOTIFICATION
#define TOP_CHILD_DISMISSED_NOTIFICATION @"TopChildDismissed"
#define PRESENT_TO_MAPPOSTVIEW_NOTIFICATION @"PresentToMapPost"

/*
 * PostViewControllert - 發文畫面 常數定義
 */
#pragma mark - PostViewController

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 4

#define TEXTFIELD_COUNTRYCITY_TAG 1000
#define TEXTFIELD_STARTDATE_TAG 2000
#define TEXTFIELD_DAYS_TAG 2001
#define IMAGEVIEW_SHAREPHOTO_TAG 3000
#define TEXTVIEW_MEMO_TAG 4000


/*
 * MapViewControllert - 地圖畫面 常數定義
*/
#pragma mark - MapViewControllert

//地圖ADD按鈕位置//
#define MAP_FLAT_BTN_CGRECTMAKE self.view.frame.size.width/2 - 15, self.view.frame.size.height - 100, 30, 30
//類別按鈕初始位置
#define FOOT_BTN_CGRECTMAKE self.view.frame.size.width/2 - 40, self.view.frame.size.height - 150, 80, 80
#define LANSCAPE_BTN_CGRECTMAKE self.view.frame.size.width/2 - 40, self.view.frame.size.height - 150, 80, 80
#define PEOPLE_BTN_CGRECTMAKE self.view.frame.size.width/2 - 40, self.view.frame.size.height - 150, 80, 80
//類別按鈕動態移動結束位置
#define FOOD_BTN_SNAP_BEHAVIOR_CGPOINT self.view.frame.size.width/2, self.view.frame.size.height/2 - 50
#define LANSCAPE_BTN_SNAP_BEHAVIOR_CGPOINT self.view.frame.size.width/2 - 110, self.view.frame.size.height/2 - 25
#define PEOPLE_BTN_SNAP_BEHAVIOR_CGPOINT self.view.frame.size.width/2 + 110, self.view.frame.size.height/2 - 25

#pragma mark - MapPostViewControllert
//地圖Po文TAG
#define IMAGEVIEW_MAPSHAREPHOTO_TAG 2000
#define TEXTVIEW_MAPMEMO_TAG 3000
//ROW & SECTION 數
#define MAPPOST_NUMBER_OF_SECTIONS 1
#define MAPPOST_NUMBER_OF_ROWS 3

//類別
#define MAPVIEW_SELECTEDTYPE_DICT_KEY @"selectedType"
//緯度
#define MAPVIEW_LATITUDE_DICT_KEY @"latitude"
//經度
#define MAPVIEW_LONGITUDE_DICT_KEY @"longitude"
//國家
#define MAPVIEW_COUNTRY_DICT_KEY @"country"
//城市
#define MAPVIEW_CITY_DICT_KEY @"city"
//鄉鎮市區
#define MAPVIEW_LOCALITY_DICT_KEY @"locality"

#define MAPVIEW_MEMO_DICT_KEY @"memo"

#define MAPVIEW_SHAREPHOTO_DICT_KEY @"sharePhoto"

/*
 * PARSE 欄位定義
*/
#pragma mark - Parse Table:TRAVELMATEPOST

#define TRAVELMATEPOST_TABLENAME @"TravelMatePost"
#define TRAVELMATEPOST_COUNTRYCITY_KEY @"countryCity"
#define TRAVELMATEPOST_STARTDATE_KEY @"startDate"
#define TRAVELMATEPOST_DAYS_KEY @"days"
#define TRAVELMATEPOST_MEMO_KEY @"memo"
#define TRAVELMATEPOST_PHOTO_KEY @"photo"
#define TRAVELMATEPOST_SMALLPHOTO_KEY @"smallPhoto"
#define TRAVELMATEPOST_ORIGINALPHOTO_KEY @"originalPhoto"
#define TRAVELMATEPOST_RELATION_COMMENTS_KEY @"comments"
#define TRAVELMATEPOST_RELATION_JOINUSERS_KEY @"joinUsers"
#define TRAVELMATEPOST_RELATION_INTERSTEDUSERS_KEY @"interestedUsers"
#define TRAVELMATEPOST_INTERESTEDCOUNT_KEY @"interestedCount"
#define TRAVELMATEPOST_COMMENTCOUNT_KEY @"commentCount"
#define TRAVELMATEPOST_JOINCOUNT_KEY @"joinCount"
#define TRAVELMATEPOST_WATCHCOUNT_KEY @"watchCount"

//使用者//
#pragma mark - Parse Table:USER

#define USER_DISPLAYNAME_KEY @"displayName"
#define USER_GENDER_KEY @"gender"
#define USER_PROFILEPICTUREMEDIUM_KEY @"profilePictureMedium"
#define USER_PROFILEPICTURESMALL_KEY @"profilePictureSmall"
#define USER_RELATION_TRAVELMATEPOSTS_KEY @"travelMatePosts"


//留言//
#pragma mark - Parse Table:COMMENT

#define COMMENT_TABLENAME @"Comment"
#define COMMENT_MESSAGE_KEY @"message"

//共通欄位名稱//
#pragma mark - Parse Common Table Col

#define COMMON_OBJECTID_KEY @"objectId"
#define COMMON_CREATEDAT_KEY @"createdAt"
#define COMMON_POINTER_CREATEUSER_KEY @"createUser"

@end
