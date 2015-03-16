//
//  LoginViewController.m
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+HM.h"
#import "ConstantValue.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
- (IBAction)loginAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *user_id=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    NSLog(@"user_id %@ , token %@",user_id,token);
    if( !OBJ_IS_NIL(user_id) && !OBJ_IS_NIL(token)){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=user_id;
        param[@"token"]=token;
        [manager GET:LOGIN_TOKEN_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result=responseObject[@"result"];
            if ([result isEqualToString:@"ok"]) {
                UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.view.window.rootViewController=mainStoryboard.instantiateInitialViewController;
            }
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }

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

- (IBAction)loginAction:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"username"]=self.loginName.text;
    param[@"passwd"]=self.loginPassword.text;
    [manager GET:LOGIN_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=responseObject[@"result"];
        if ([result isEqualToString:@"ok"]) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"user_id"] forKey:@"user_id"];
            [defaults setObject:responseObject[@"token"] forKey:@"token"];
            [defaults synchronize];
            UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.view.window.rootViewController=mainStoryboard.instantiateInitialViewController;
        }else{
            [MBProgressHUD showError:@"用户名和密码错误！"];
            self.loginPassword.text=@"";
            self.loginName.text=@"";
            [self.loginName becomeFirstResponder];
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络连接发生问题！"];
        NSLog(@"Error: %@", error);
    }];
}
@end
