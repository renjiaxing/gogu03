//
//  MicropostsTableCell.h
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Micropost.h"

@interface MicropostsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *micropostContent;
@property (weak, nonatomic) IBOutlet UILabel *micropostTime;
@property (weak, nonatomic) IBOutlet UIButton *stockName;
@property (weak, nonatomic) IBOutlet UIButton *imageLike;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UIButton *imageComment;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UIButton *imageChat;
@property (weak, nonatomic) IBOutlet UIButton *imageDel;
@property (weak, nonatomic) IBOutlet UIButton *imageChange;
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;

@property (strong,nonatomic) Micropost *micropost;
@end
