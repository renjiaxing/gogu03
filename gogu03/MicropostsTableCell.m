//
//  MicropostsTableCell.m
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "MicropostsTableCell.h"
#import "AFNetworking.h"
#import "ConstantValue.h"

@implementation MicropostsTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)changeLike:(id)sender {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *user_id=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    
    UIButton *buttonLike=(UIButton *)sender;
    Micropost *micropost=self.micropost;
    if ([micropost.good isEqualToString:@"true"]) {
        [buttonLike setBackgroundImage:[UIImage imageNamed:@"ic_card_like_grey"] forState:UIControlStateNormal];
        micropost.good=@"false";
        int tempNum=micropost.good_number.intValue;
        tempNum-=1;
        micropost.good_number=[NSNumber numberWithInt:tempNum];
        self.likeNumber.text=[NSString stringWithFormat:@"%@",micropost.good_number];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=user_id;
        param[@"token"]=token;
        param[@"mid"]=micropost.id;
        
        [manager GET:NOGOOD_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result=responseObject[@"result"];
            
            NSLog(@"%@",result);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }else{
        [buttonLike setBackgroundImage:[UIImage imageNamed:@"ic_card_liked"] forState:UIControlStateNormal];
        micropost.good=@"true";
        int tempNum=micropost.good_number.intValue;
        tempNum+=1;
        micropost.good_number=[NSNumber numberWithInt:tempNum];
                self.likeNumber.text=[NSString stringWithFormat:@"%@",micropost.good_number];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=user_id;
        param[@"token"]=token;
        param[@"mid"]=micropost.id;
        
        [manager GET:GOOD_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result=responseObject[@"result"];
            
            NSLog(@"%@",result);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

@end
