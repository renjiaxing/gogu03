//
//  testViewController.m
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()


@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailMicropost.text=self.content;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
