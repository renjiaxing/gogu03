//
//  testViewController.h
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *detailMicropost;
@property (copy,nonatomic) NSString *content;
@end
