//
//  DetailMicropostController.h
//  gogu03
//
//  Created by ren on 15/3/3.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Micropost.h"

@interface DetailMicropostController : UIViewController
@property (strong,nonatomic) NSNumber *micropost_id;
@property (strong,nonatomic) Micropost *micropost;
@end
