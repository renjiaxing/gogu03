//
//  AppDelegate.h
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define SERV_URL @"http://121.41.25.221"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

