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

@interface HomeDetailViewController ()
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation HomeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"Cell Array Data = %@",_cellArrayData);
    
    //設定Navigation bar為透明
    self.navigationController.navigationBar.translucent = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[user objectForKey:kPAPUserProfilePicSmallKey];

    
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
    [button setTitle:@"按鈕" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(alert:) forControlEvents:UIControlEventTouchUpInside];
    [self addHeaderOverlayView:button];
    
    //關閉分隔線
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor homeCellbgColor];
    self.view.opaque = NO;
    self.tableView.backgroundColor = [UIColor homeCellbgColor];
    self.tableView.opaque = NO;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"JLCell";
    NSString *nibName = @"JLTableViewCell";
    
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        identifier = @"JL2Cell";
        nibName = @"JL2TableViewCell";
    }
    
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    JLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        [self prepareJLCellstyle:cell cellForRowAtIndexPath:indexPath];
        [self setJLCellData:cell cellForRowAtIndexPath:indexPath];
        
    } else {
        //JL2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) prepareJLCellstyle:(JLTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //設定邊框粗細
    //[[cell.firstSectionView layer] setBorderWidth:1.5];
    
    //邊框顏色
    //[[cell.firstSectionView layer] setBorderColor:[UIColor colorWithRed:0.806 green:0.806 blue:0.806 alpha:1.0].CGColor];
    
    //設定背景顏色
    [[cell.firstSectionView layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    cell.backgroundColor = [UIColor homeCellbgColor];
    
    //設定圓角程度
    //[[cell.firstSectionView layer] setCornerRadius:10.0];
    
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
    cell.memo.textColor = [UIColor whiteColor];
    cell.memo.textAlignment = NSTextAlignmentLeft;  //內文對齊方式
    [cell.memo setBackgroundColor:[UIColor redColor]];
    cell.memo.text = _cellDictData[@"memo"];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result;
    
    if(indexPath.section == 0){
        result = 200.0f;
        
        NSString * memo = _cellDictData[@"memo"];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:memo attributes:attributes];
        
        //CGSizeZero 建議限制高度
        CGRect rect = [attrString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading context:nil];
        NSLog(@"string= %@",memo);
//        NSLog(@"rect:%@",NSStringFromCGRect(rect));
        result += rect.size.height;
//        result = 20.0f;
//        cell.memo.text = _cellDictData[@"memo"];
//        
//        
//        
//        CGFloat textWidth = cell.memo.frame.size.width;
//        
//        CGRect rect = [cell.memo.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//        
//        cell.memo.frame = CGRectMake(0, 0, textWidth,rect.size.height);
//        
//        result += rect.size.height;
//        
//        NSLog(@"%f",rect.size.height);
        
    }else{
        result = 44.0f;
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
