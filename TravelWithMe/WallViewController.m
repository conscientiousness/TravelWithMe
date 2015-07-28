//
//  WallViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/23.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "WallViewController.h"
#import "WallTableViewCell.h"
#import "HomePostViewController.h"
#import "HomeDetailViewController.h"
#import "UIColors.h"

@interface WallViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *wallTableView;


@end

@implementation WallViewController
{
    CGFloat imgWidth;
    CGFloat imgHeight;
    UIImage *image;
    float imgRatio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initUI];
    _wallTableView.scrollEnabled = YES;
    _wallTableView.delegate = self;
    _wallTableView.dataSource = self;
    
    image = [UIImage imageNamed:@"iphone_h_photo.jpg"];
    
    imgWidth = image.size.width;
    imgHeight = image.size.height;
    imgRatio = (float)imgWidth/(float)imgHeight;
    
}



//初始化UI畫面
- (void)initUI {
        
    //關閉分隔線
    [_wallTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //設定背景色
    //[_homeTableView setBackgroundView:nil];
    //_wallTableView.backgroundColor = [UIColor homeCellbgColor];
    //透明度
    _wallTableView.opaque = NO;
        
    //Add post Button
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(postBtnPressed:)];
        
    self.navigationItem.rightBarButtonItem = postButton;
        
    //navigation bar color
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor navigationBarColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //tab bar color
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor tabBarColor]];
    self.tabBarController.tabBar.barTintColor = [UIColor tabBarColor];
    self.tabBarController.tabBar.translucent = NO;
}

    
    
- (void)postBtnPressed:(id *)sender {
        
        HomePostViewController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"postViewController"];
        
        [self.navigationController pushViewController:postVC animated:YES];
        
        
        //[self presentViewController:postVC animated:YES completion:nil];
        //[self performSegueWithIdentifier:@"goPostView" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 1){
        if(indexPath.row == 1) {
            
        }
    }
    
    NSString *identifier =@"wallTableViewCell";
    
    UITableViewCell *cell = [self prepareTableViewCell:tableView cellForRowAtIndexPath:indexPath cellIdentifier:identifier];
    
    return cell;
}


- (UITableViewCell *)prepareTableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellIdentifier:(NSString *)identifier{
    
    WallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    //====Set Cell Style====
    cell.contentView.backgroundColor =[UIColor homeCellbgColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    [[cell.viewInTableViewCell layer] setBorderWidth:0];
    
    //邊框顏色
    //[[wallTableViewCell.viewInTableViewCell layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    //[[vocDataCell.vocDataCell layer] setMasksToBounds:YES];
    
    //設定背景顏色
    [[cell.viewInTableViewCell layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    
    //設定圓角程度
    [[cell.viewInTableViewCell layer] setCornerRadius:0];
    
    //照片圓形遮罩
    cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    cell.headPhoto.layer.borderWidth = 3.0f;
    cell.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    cell.headPhoto.clipsToBounds = YES;
    
    
    //字體粗細大小
    cell.testAreaLabel.font = [UIFont systemFontOfSize:11];
    //文字顏色
    cell.testAreaLabel.textColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000];
    //背景色
    cell.testAreaLabel.backgroundColor = [UIColor clearColor];
    //Lable邊框
    cell.testAreaLabel.layer.borderColor = [UIColor colorWithRed:0.373 green:0.710 blue:0.647 alpha:1.000].CGColor;
    cell.testAreaLabel.layer.borderWidth = 0.5;
    cell.testAreaLabel.layer.cornerRadius = 3;
    //文字在Label置中
    cell.testAreaLabel.textAlignment = NSTextAlignmentCenter;
    //文字自動適應Lable大小
    cell.testAreaLabel.adjustsFontSizeToFitWidth = NO;
    
    cell.viewBlock1.backgroundColor = [UIColor whiteColor];
    cell.viewBlock2.backgroundColor = [UIColor whiteColor];
    cell.viewBlock3.backgroundColor = [UIColor whiteColor];

    
    /*/====Add Image View====
    CGFloat viewInCellWidth = cell.viewInTableViewCell.frame.width;
    CGFloat viewInCellHeight = cell.contentView.frame.size.height;
    
    NSLog(@"viewInCellWidth= %f, viewInCellHeight= %f , index = %ld",viewInCellWidth,viewInCellHeight,(long)indexPath.row);
    
    
    // 初始化
    UIImageView *dyImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,cell.viewBlock2.frame.origin.y + cell.viewBlock2.frame.size.height ,320,240)];
    //320  橫：240  直：426.666666
    
    // 圖片檔案引入UIImage物件(需要先將圖片加入專案中)
    // initWithNamed:@"cropped-Logo"]];
    UIImage *dyImage = [UIImage imageNamed:@"iphone_h_photo.jpg"];
    dyImageView.contentMode = UIViewContentModeTop;
    dyImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    // 圖片影像物件指定至UIImageView之影象
    dyImageView.image = dyImage;
    dyImageView.backgroundColor =[UIColor redColor];
    
    
    // UIImageView加入主要View中
    //[cell.viewInTableViewCell addSubview:dyImageView];
    
    //NSLog(@"%@",cell.viewInTableViewCell.subviews);
    */
    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat result;
    result = 492.0;
 
    
    return result;
}




//當選擇某一列Cell要做的的動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳轉到HomePostViewController
    HomePostViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //傳值
    NSNumber *value = [NSNumber numberWithLong:indexPath.row];
    [detailVC setValue:value forKey:@"test"];
    
    //NSLog(@"hey");
    
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
