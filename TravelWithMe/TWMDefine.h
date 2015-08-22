//
//  TWMDefine.h
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/19.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWMDefine : NSObject

//*//
#pragma mark - PostViewController

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 4

#define TEXTFIELD_COUNTRYCITY_TAG 1000
#define TEXTFIELD_STARTDATE_TAG 2000
#define TEXTFIELD_DAYS_TAG 2001
#define IMAGEVIEW_SHAREPHOTO_TAG 3000
#define TEXTVIEW_MEMO_TAG 4000

//*//
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

//*//
#pragma mark - Parse Table:USER

#define USER_DISPLAYNAME_KEY @"displayName"
#define USER_GENDER_KEY @"gender"
#define USER_PROFILEPICTUREMEDIUM_KEY @"profilePictureMedium"
#define USER_PROFILEPICTURESMALL_KEY @"profilePictureSmall"
#define USER_RELATION_TRAVELMATEPOSTS_KEY @"travelMatePosts"


//*//
#pragma mark - Parse Table:COMMENT

#define COMMENT_TABLENAME @"Comment"
#define COMMENT_MESSAGE_KEY @"message"

//*共通欄位名稱//
#pragma mark - Parse Common Table Col

#define COMMON_OBJECTID_KEY @"objectId"
#define COMMON_CREATEDAT_KEY @"createdAt"
#define COMMON_POINTER_CREATEUSER_KEY @"createUser"

@end
