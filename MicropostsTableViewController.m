//
//  MicropostsTableViewController.m
//  gogu03
//
//  Created by ren on 15/2/25.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "MicropostsTableViewController.h"
#import "MicropostsTableCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "Micropost.h"
#import "MJRefresh.h"
#import "DetailMicropostController.h"
#import "ConstantValue.h"



@interface MicropostsTableViewController () <UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray *micropostsArray;
@property(strong,nonatomic) NSNumber *maxId;
@property(strong,nonatomic) NSNumber *minId;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *token;
@end

@implementation MicropostsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    NSLog(@"user_id %@ , token %@",self.user_id,self.token);
    
    self.micropostsArray=[NSMutableArray array];
    
    if(self.stock_name){
        self.navigationItem.title=self.stock_name;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    if(self.stock_id){
        param[@"stock_id"]=self.stock_id;
    }

    [manager GET:MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        for (NSDictionary *mico in micropostsDict) {
            Micropost *micropost=[Micropost objectWithKeyValues:mico];
            NSLog(@"micropost:%@",micropost.content);
            [self.micropostsArray addObject:micropost];
        }

        self.maxId=((Micropost *)self.micropostsArray[0]).id;
        self.minId=((Micropost *)self.micropostsArray[[self.micropostsArray count]-1]).id;
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self setupRefresh];


}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在努力加载中～";
    
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在努力加载中～";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"up"]=self.maxId;
    if(self.stock_id){
        param[@"stock_id"]=self.stock_id;
    }

    [manager GET:UP_MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        for (NSDictionary *mico in micropostsDict) {
            Micropost *micropost=[Micropost objectWithKeyValues:mico];
            NSLog(@"micropost:%@",micropost.content);
            [self.micropostsArray insertObject:micropost atIndex:0];
        }
        
        
        self.maxId=((Micropost *)self.micropostsArray[0]).id;
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.tableView headerEndRefreshing];
}

- (void)footerRereshing
{
    // 1.添加假数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"down"]=self.minId;
    if(self.stock_id){
        param[@"stock_id"]=self.stock_id;
    }
    [manager GET:DOWN_MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        for (NSDictionary *mico in micropostsDict) {
            Micropost *micropost=[Micropost objectWithKeyValues:mico];
            NSLog(@"micropost:%@",micropost.content);
            [self.micropostsArray addObject:micropost];
        }
        

        self.minId=((Micropost *)self.micropostsArray[[self.micropostsArray count]-1]).id;
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.tableView footerEndRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[self.micropostsArray count]);
    return [self.micropostsArray count];
}

- (CGFloat)getCellHeight:(UITableViewCell*)cell
{
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    //通过systemLayoutSizeFittingSize返回最低高度
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"MicropostsTableCell";
//    static MicropostsTableCell *cell=nil;
//    if (cell==nil) {
//        cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    }
    
    MicropostsTableCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell){
        cell=[[MicropostsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    Micropost *micropost=self.micropostsArray[indexPath.row];
    cell.micropostContent.text=micropost.content;
    cell.micropostTime.text=micropost.created_at;
    [cell.stockName setTitle:micropost.stock_name forState:UIControlStateNormal];
    cell.likeNumber.text=[NSString stringWithFormat:@"%@",micropost.good_number];
    cell.commentNumber.text=[NSString stringWithFormat:@"%@",micropost.comment_number];
    if ([micropost.good isEqualToString:@"true"]) {
        [cell.imageLike setBackgroundImage:[UIImage imageNamed:@"ic_card_liked"] forState:UIControlStateNormal];
    }else{
        [cell.imageLike setBackgroundImage:[UIImage imageNamed:@"ic_card_like_grey"] forState:UIControlStateNormal];
        
    }

    if ([micropost.image isEqualToString:@""]) {
        return [self getCellHeight:cell]-90;
    }else{
        return [self getCellHeight:cell];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier=@"MicropostsTableCell";
    MicropostsTableCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell){
        cell=[[MicropostsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    Micropost *micropost=self.micropostsArray[indexPath.row];
    cell.micropost=micropost;
    cell.micropostContent.text=micropost.content;
    cell.micropostTime.text=micropost.created_at;
    [cell.stockName setTitle:micropost.stock_name forState:UIControlStateNormal];
    cell.likeNumber.text=[NSString stringWithFormat:@"%@",micropost.good_number];
    cell.commentNumber.text=[NSString stringWithFormat:@"%@",micropost.comment_number];
    if ([micropost.good isEqualToString:@"true"]) {
        [cell.imageLike setBackgroundImage:[UIImage imageNamed:@"ic_card_liked"] forState:UIControlStateNormal];
        
    }else{
        [cell.imageLike setBackgroundImage:[UIImage imageNamed:@"ic_card_like_grey"] forState:UIControlStateNormal];
    }
    
    if(self.stock_id){
        cell.stockName.hidden=YES;
    }else{
        cell.stockName.hidden=NO;
    }
    
    if ([micropost.image isEqualToString:@""]) {
        cell.imagePic.hidden=true;
    }else{
        cell.imagePic.hidden=false;
        [cell.imagePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERV_URL,micropost.image]] placeholderImage:[UIImage imageNamed: @"0"]];
        NSLog(@"%@%@",SERV_URL,micropost.image);
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailMicropost"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailMicropostController *destViewController = segue.destinationViewController;
        destViewController.micropost_id = ((Micropost *)self.micropostsArray[indexPath.row]).id;
        destViewController.micropost=(Micropost *)self.micropostsArray[indexPath.row];
    }else if ([segue.identifier isEqualToString:@"showInterestMicropost"]){
        MicropostsTableCell *cell=(MicropostsTableCell *)[[sender superview] superview];
        NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
        NSLog(@"indexis :%ld",(long)indexPath.row);
        MicropostsTableViewController *destViewController=segue.destinationViewController;
        destViewController.stock_id=((Micropost *)self.micropostsArray[indexPath.row]).stock_id;
        destViewController.stock_name=((Micropost *)self.micropostsArray[indexPath.row]).stock_name;
        NSLog(@"indexis :%ld",(long)destViewController.stock_id);
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
