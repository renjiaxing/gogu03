//
//  ConstantValue.h
//  gogu03
//
//  Created by ren on 15/2/28.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define MARGIN_CONTENT 10
#define MARGIN_SMALLCONTENT 5
#define BUTTON_HEIGHT 35


//#define SERV_URL @"http://121.41.25.221"
#define SERV_URL @"http://127.0.0.1:3000"
#define MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/microposts_json",SERV_URL]
#define DOWN_MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/down_microposts_json",SERV_URL]
#define UP_MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/up_microposts_json",SERV_URL]
#define LOGIN_TOKEN_URL [NSString stringWithFormat:@"%@/apijson/login_token_json",SERV_URL]
#define LOGIN_URL [NSString stringWithFormat:@"%@/apijson/login_json",SERV_URL]
#define GOOD_MICROPOST_URL [NSString stringWithFormat:@"%@/micropost_good_json",SERV_URL]
#define NOGOOD_MICROPOST_URL [NSString stringWithFormat:@"%@/micropost_nogood_json",SERV_URL]
#define DETAIL_MICROPOST_URL [NSString stringWithFormat:@"%@/apijson/detail_micropost_json",SERV_URL]
#define COMMENT_PIC_URL [NSString stringWithFormat:@"%@/user_pic/",SERV_URL]
#define NEW_COMMENT_URL [NSString stringWithFormat:@"%@/apijson/new_comment_json",SERV_URL]

@interface ConstantValue : NSObject

@end
