//
//  HomeDetailViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/10.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "UIColors.h"
#import "JLTableViewCell.h"
#import "JL2TableViewCell.h"
#import "JL3MessageTableViewCell.h"

@interface HomeDetailViewController ()

@end

@implementation HomeDetailViewController
{
    UIView *menuViewRelative;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //置頂照片
    [self setHeaderImage:[UIImage imageNamed:@"tmp900X640.png"]];
    PFFile *PFPhoto = (PFFile*)_cellDictData[@"photo"];
    [PFPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self setHeaderImage:[UIImage imageWithData:imageData]];
        }
    }];
    //置頂標題:國家城市
    [self setTitleText:_cellDictData[@"countryCity"]];
    //置頂副標題:地區
    [self setSubtitleText:_cellDictData[@"locationTag"]];
    [self setLabelBackgroundGradientColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    //[self setInteractionsDelegate:self];
    CGFloat headerHeight = [self headerHeight];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, headerHeight - 55, 44, 44)];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(alert:) forControlEvents:UIControlEventTouchUpInside];
    [self addHeaderOverlayView:button];
    
    //設定Navigation bar為透明
    self.navigationController.navigationBar.translucent = YES;
    //關閉分隔線
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor homeCellbgColor];
    self.view.opaque = NO;
    self.tableView.backgroundColor = [UIColor homeCellbgColor];
    self.tableView.opaque = NO;
    
    
    /*NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"JL2TableViewCell" owner:self options:nil];
    UIView *mainView = [subviewArray objectAtIndex:0];
    mainView.layer.zPosition = 0.1;
    [self.view addSubview:mainView];*/
    

}


- (void)alert:(UIButton*)sender{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can even add buttons to the header!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@":)", nil] show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 0;
    } else if (section == 2){
        return 10;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier;
    NSString *nibName;
    
    if (indexPath.section == 0) {
        identifier = @"JLCell";
        nibName = @"JLTableViewCell";
    } else if (indexPath.section == 1){
        identifier = @"JL2Cell";
        nibName = @"JL2TableViewCell";
    } else if (indexPath.section == 2){
        identifier = @"JL3MessageCell";
        nibName = @"JL3MessageTableViewCell";
    }
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    
    
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        
        [self prepareJLCellstyle:(JLTableViewCell *)cell cellForRowAtIndexPath:indexPath];
        [self setJLCellData:(JLTableViewCell*)cell cellForRowAtIndexPath:indexPath];
        
    } else if(indexPath.section == 1) {
        [self prepareJL2Cellstyle:(JL2TableViewCell *)cell cellForRowAtIndexPath:indexPath];
        //[self setJLCellData:(JLTableViewCell*)cell cellForRowAtIndexPath:indexPath];

    } else if(indexPath.section == 2) {
        [self prepareJL3MessagCellstyle:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void) prepareJLCellstyle:(JLTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //點選時的顏色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    //[[cell.firstSectionView layer] setBorderWidth:1.5];
    
    //邊框顏色
    //[[cell.firstSectionView layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //設定背景顏色
    //[[cell.firstSectionView layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    //設定圓角程度
    [[cell.firstSectionView layer] setCornerRadius:5.0];
    
    //照片圓形遮罩
    cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    cell.headPhoto.layer.borderWidth = 3.0f;
    cell.headPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    cell.headPhoto.clipsToBounds = YES;
    
    //按鈕
    cell.joinBtn.layer.cornerRadius = 15.0;
}

- (void) setJLCellData:(JLTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //大頭照
    [cell.headPhoto setImage:[UIImage imageNamed:@"pic1.jpg"]];
    PFFile *PFPhoto = (PFFile*)_cellDictData[@"profilePictureMedium"];
    [PFPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [cell.headPhoto setImage:[UIImage imageWithData:imageData]];
        }
    }];
    
    //名字
    cell.displayName.text = _cellDictData[@"displayName"];
    //出發日期
    cell.travelDate.text = _cellDictData[@"startDate"];
    
    //更多說明
    cell.memo.numberOfLines = 0;  //需定義為0才會換行
    //cell.memo.textColor = [UIColor whiteColor];
    cell.memo.textAlignment = NSTextAlignmentLeft;  //內文對齊方式
    //[cell.memo setBackgroundColor:[UIColor redColor]];
    cell.memo.text = _cellDictData[@"memo"];
    //NSLog(@"label height= %f, width= %f",cell.memo.frame.size.height,cell.memo.frame.size.width);
}

- (void) prepareJL2Cellstyle:(JL2TableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //點選時的顏色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    //[[cell.firstSectionView layer] setBorderWidth:1.5];
    
    //邊框顏色
    //[[cell.firstSectionView layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //設定背景顏色
    [[cell.secondSectionView layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    cell.backgroundColor = [UIColor homeCellbgColor];
    
    //設定圓角程度
    [[cell.secondSectionView layer] setCornerRadius:10.0];
    
    //照片圓形遮罩
    //cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    //cell.headPhoto.layer.borderWidth = 3.0f;
    //cell.headPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    //cell.headPhoto.clipsToBounds = YES;
    
    //按鈕
    //cell.joinBtn.layer.cornerRadius = 15.0;
}

- (void) prepareJL3MessagCellstyle:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //點選時的顏色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //設定邊框粗細
    //[[cell.firstSectionView layer] setBorderWidth:1.5];
    
    //邊框顏色
    //[[cell.firstSectionView layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //設定背景顏色
    [[cell.thirdSectionView layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    cell.backgroundColor = [UIColor homeCellbgColor];
    
    //設定圓角程度
    [[cell.thirdSectionView layer] setCornerRadius:5.0];
    
    //照片圓形遮罩
    //cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    //cell.headPhoto.layer.borderWidth = 3.0f;
    //cell.headPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    //cell.headPhoto.clipsToBounds = YES;
    
    //按鈕
    //cell.joinBtn.layer.cornerRadius = 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result;
    
    if(indexPath.section == 0){
        result = 304.0;
        
        NSString * memo = _cellDictData[@"memo"];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:memo attributes:attributes];
        
        //寬度固定計算行高(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
        CGRect rect = [attrString boundingRectWithSize:CGSizeMake(296.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        //NSLog(@"rect:%@",NSStringFromCGRect(rect));
        //NSLog(@"rect height = %f",rect.size.height);
        result += rect.size.height;
        
    }else{
        result = 80.0;
    }
    
    return result;
}

- (CGFloat)horizontalOffset{
    return 50.0f;
}

- (void)didTapHeaderImageView:(UIImageView *)imageView
{
    NSLog(@"The header imageview was tapped: %@", imageView.description);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
