//
//  DetailMessageViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/9.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "DetailMessageViewController.h"
#import "UIColors.h"
#import "JLTableViewCell.h"
#import "JL2TableViewCell.h"
#import "JL3MessageTableViewCell.h"
#import "ParallaxHeaderView.h"
#import "UIImage+ImageEffects.h"
#import "SSBouncyButton.h"
#import "DateTools.h"

//個人資料cell高度
#define HEIGHT_FOR_INFO_CELL 330.0
//訊息cell高度
#define HEIGHT_FOR_MESSAGE_CELL 64.0
//行程介紹Label寬度:影響系統動態變更高度
#define WIDTH_FOR_MEMO_LABEL 210.0

@interface DetailMessageViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@end

@implementation DetailMessageViewController
{
    UIImage *headerPhoto;
    UIImage *blurImage;
    UIImageView *blurImageView;
    UIVisualEffectView *blurredView;
    ParallaxHeaderView *headerView;
    SSBouncyButton *customJoinButton;
    PFUser *user;
    NSNumber *isJoin;
    NSNumber *isInterested;
    MBProgressHUD *hud;
    NSMutableArray *commentAry;
    NSMutableDictionary *dictCountData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _detailTableView.scrollEnabled = YES;
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        blurImage = [UIImage imageNamed:@"bg-blur-image"];
        blurImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [blurImageView setImage:[blurImage applyDarkEffect]];
    }
    else
    {
        //blur效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurredView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        blurredView.frame = self.view.bounds;
        blurredView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:blurredView];
    }
    
    //手勢控制鍵盤縮放
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethof:)];
    [self.view addGestureRecognizer:clickGesture];
    //鍵盤出現時發出通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHeightDidChange:) name:UIKeyboardWillShowNotification object:nil];
    
    
    //設定Navigation bar為透明
    self.navigationController.navigationBar.translucent = YES;
    //關閉分隔線
    [_detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor homeCellbgColor];
    self.view.opaque = NO;
    _detailTableView.backgroundColor = [UIColor homeCellbgColor];
    _detailTableView.opaque = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
    if (!user) {
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    
    hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    dispatch_queue_t downloadDatasQueue = dispatch_queue_create("Download", nil);
    //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(downloadDatasQueue, ^{
        
        //Get Data from Parse
        [self getPhotoFile];
        [self getRelationData];
        [self getCommentData];
        [self getCountData];
        [self incrementWatchCount];
        
        //Back main Thread update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didGotDatasUpdateUI];
        });
    });
    
    //留言尚未登入時鎖定
    if(!user){
        _messageTextField.userInteractionEnabled = NO;
        _messageTextField.placeholder = @"要先登入才能留言哦";
        //_messageBtn.userInteractionEnabled = NO;
    } else {
        _messageTextField.userInteractionEnabled = YES;
        _messageTextField.placeholder = @"";
    }
}

#pragma mark - 點選參加
- (void)joinButtonDidPress:(UIButton *)button
{
    button.selected = !button.selected;
    
    //NSLog(@"%d",button.selected);
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.labelText = @"Loading...";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            PFObject *travelMatePost = [PFObject objectWithoutDataWithClassName:@"TravelMatePost" objectId:_cellDictData[@"objectId"]];
            PFRelation *userRelation = [user relationForKey:@"joinPosts"];
            PFRelation *postRelation = [travelMatePost relationForKey:@"joinUsers"];
            
            if(button.selected) { //儲存"參加"關聯
                
                [userRelation addObject:travelMatePost];
                [user save];
                
                [travelMatePost incrementKey:@"joinCount"];
                
                [postRelation addObject:user];
                [travelMatePost save];
                
            } else { //解除"參加"關聯
                
                [userRelation removeObject:travelMatePost];
                [user save];
                
                [travelMatePost incrementKey:@"joinCount" byAmount:@-1];
                
                [postRelation removeObject:user];
                [travelMatePost save];
            }
            
            [self getRelationData];
            [self getCountData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_detailTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
        
    }
}

#pragma mark - 點選有興趣
- (void)interestedBtnPressed:(UIButton *)button
{
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.labelText = @"Loading...";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            PFObject *travelMatePost = [PFObject objectWithoutDataWithClassName:@"TravelMatePost" objectId:_cellDictData[@"objectId"]];
            PFRelation *userRelation = [user relationForKey:@"interestedPosts"];
            PFRelation *postRelation = [travelMatePost relationForKey:@"interestedUsers"];
            
            if([isInterested integerValue]==0)//目前User沒興趣,儲存"有興趣"關聯
            {
                [userRelation addObject:travelMatePost];
                [user save];
                
                [travelMatePost incrementKey:@"interestedCount"];
                
                [postRelation addObject:user];
                [travelMatePost save];
                
            } else { //解除"參加"關聯
                
                [userRelation removeObject:travelMatePost];
                [user save];
                
                [travelMatePost incrementKey:@"interestedCount" byAmount:@-1];
                
                [postRelation removeObject:user];
                [travelMatePost save];
            }
            
            [self getRelationData];
            [self getCountData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([isInterested integerValue]==0){
                    [button setImage:[UIImage imageNamed:@"interested-icon"] forState:UIControlStateNormal];
                } else {
                    [button setImage:[UIImage imageNamed:@"no-interested-add-icon"] forState:UIControlStateNormal];
                }
                
                [_detailTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
        
    }
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
        return commentAry.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat result;
    NSString *tmpStr;
    
    if(indexPath.section == 0){
        result = HEIGHT_FOR_INFO_CELL;
        
        tmpStr = _cellDictData[@"memo"];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:tmpStr attributes:attributes];
        
        //寬度固定計算行高(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
        CGRect rect = [attrString boundingRectWithSize:CGSizeMake(WIDTH_FOR_MEMO_LABEL, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        //NSLog(@"rect:%@",NSStringFromCGRect(rect));
        //NSLog(@"rect height = %f",rect.size.height);
        result += rect.size.height;
        
        //如果使用者為原PO,參加按鈕隱藏
        if([user.objectId isEqualToString:_cellDictData[@"userObjectId"]])
            result -= 50.0;
        
    }else if(indexPath.section == 2){
        result = HEIGHT_FOR_MESSAGE_CELL
        ;
        
        tmpStr = commentAry[indexPath.row][COMMENT_MESSAGE_KEY];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:tmpStr attributes:attributes];
        
        //寬度固定計算行高(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
        CGRect rect = [attrString boundingRectWithSize:CGSizeMake(296.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        result += rect.size.height;
    }else {
        result = 80.0;
    }
    
    return result;
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
    
    //NSLog(@"cell = %@ ,section = %ld,row = %ld",cell,indexPath.section,indexPath.row);
    
    if(indexPath.section == 0) {
        [self prepareJLCellstyle:(JLTableViewCell *)cell cellForRowAtIndexPath:indexPath];
        [self setJLCellData:(JLTableViewCell*)cell cellForRowAtIndexPath:indexPath];
        
    } else if(indexPath.section == 1) {
        [self prepareJL2Cellstyle:(JL2TableViewCell *)cell cellForRowAtIndexPath:indexPath];
        //[self setJLCellData:(JLTableViewCell*)cell cellForRowAtIndexPath:indexPath];
        
    } else if(indexPath.section == 2) {
        [self prepareJL3MessageCellstyle:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:indexPath];
        [self setJL3MessageCellData:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - 個人資料UI
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
    
    NSString *gender = _cellDictData[@"gender"];
    UIColor *genderColor;
    //照片圓形遮罩
    if([gender isEqualToString:@"male"]) {
        genderColor = [UIColor boyPhotoBorderColor];
    } else if([gender isEqualToString:@"female"]) {
        genderColor = [UIColor girlPhotoBorderColor];
    } else {
        genderColor = [UIColor customGreenColor];
    }
    
    cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    cell.headPhoto.layer.borderWidth = 3.0f;
    cell.headPhoto.layer.borderColor = genderColor.CGColor;
    cell.headPhoto.clipsToBounds = YES;
    
    //參加按鈕
    if(![user.objectId isEqualToString:_cellDictData[@"userObjectId"]]) {
        if (customJoinButton==nil) {
            CGRect btnBounds = cell.joinBtn.bounds;
            if([[UIScreen mainScreen] bounds].size.height >= 667.0){
                btnBounds.origin.y = cell.frame.size.height - btnBounds.size.height - 20;
                btnBounds.size.height += 5;
                btnBounds.size.width += 5;
            }else{
                btnBounds.origin.y = cell.frame.size.height - btnBounds.size.height - 5;
            }
            
            btnBounds.origin.x = cell.frame.size.width/2 - btnBounds.size.width/2;
            //NSLog(@"height = %f",[[UIScreen mainScreen] bounds].size.height);
            // tintColor, cornerRadius
            customJoinButton = [[SSBouncyButton alloc] initWithFrame:btnBounds];
            
            customJoinButton.tintColor = [UIColor customGreenColor];
            customJoinButton.cornerRadius = 10;
            customJoinButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
            [customJoinButton setTitle:@"參加" forState:UIControlStateNormal];
            [customJoinButton setTitle:@"退出" forState:UIControlStateSelected];
            [customJoinButton addTarget:self action:@selector(joinButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:customJoinButton];
        }
    }
    cell.joinBtn.hidden = YES;
    if([isJoin integerValue]>0)//目前User已參加
        customJoinButton.selected = YES;
    else
        customJoinButton.selected = NO;
    
    
    if([isInterested integerValue]>0)//目前User有興趣
        [cell.interestedBtn setImage:[UIImage imageNamed:@"interested-icon"] forState:UIControlStateNormal];
    else
        [cell.interestedBtn setImage:[UIImage imageNamed:@"no-interested-add-icon"] forState:UIControlStateNormal];
    
    [cell.interestedBtn addTarget:self action:@selector(interestedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 個人資料Data
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
    //旅遊天數
    cell.days.text = [(NSNumber*)_cellDictData[@"days"] stringValue];
    
    //更多說明
    cell.memo.numberOfLines = 0;  //需定義為0才會換行
    //cell.memo.textColor = [UIColor whiteColor];
    cell.memo.textAlignment = NSTextAlignmentLeft;  //內文對齊方式
    //[cell.memo setBackgroundColor:[UIColor redColor]];
    cell.memo.text = _cellDictData[@"memo"];
    //NSLog(@"label height= %f, width= %f",cell.memo.frame.size.height,cell.memo.frame.size.width);
    
    //有興趣數
    cell.interestedLabel.text = [NSString stringWithFormat:@"%@ 個有興趣",dictCountData[@"interestedCount"]];
    //留言數
    cell.commentLabel.text = [NSString stringWithFormat:@"%@ 則留言",dictCountData[@"commentCount"]];
    //參加數
    cell.joinLabel.text = [NSString stringWithFormat:@"%@ 人參加",dictCountData[@"joinCount"]];
    
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


#pragma mark - 留言UI

- (void) prepareJL3MessageCellstyle:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    //留言
    cell.messageLabel.numberOfLines = 0;  //需定義為0才會換行
    //cell.memo.textColor = [UIColor whiteColor];
    cell.messageLabel.textAlignment = NSTextAlignmentLeft;  //內文對齊方式
    //[cell.memo setBackgroundColor:[UIColor redColor]];
    
    //照片圓形遮罩
    //cell.headPhoto.layer.cornerRadius = cell.headPhoto.frame.size.width / 2;
    //cell.headPhoto.layer.borderWidth = 3.0f;
    //cell.headPhoto.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    //cell.headPhoto.clipsToBounds = YES;
    
}

#pragma mark - 留言Data
- (void) setJL3MessageCellData:(JL3MessageTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //大頭照
    //[cell.messageUserPhoto setImage:commentAry[indexPath.row][USER_PROFILEPICTURESMALL_KEY]];
    
    //名字
    //cell.messageUserName.text = commentAry[indexPath.row][USER_DISPLAYNAME_KEY];
    
    [cell.messageUserPhoto setImage:[UIImage imageNamed:@"tmp-head-icon"]];
    PFFile *PFPhoto = (PFFile*)commentAry[indexPath.row][@"createUser"][@"profilePictureSmall"];
    [PFPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [cell.messageUserPhoto setImage:[UIImage imageWithData:imageData]];
        }
    }];
    
    //名字
    cell.messageUserName.text = commentAry[indexPath.row][@"createUser"][@"displayName"];
    
    //訊息
    cell.messageLabel.text = commentAry[indexPath.row][COMMENT_MESSAGE_KEY];
    
    //NSLog(@"%@",((PFObject*)commentAry[indexPath.row]).createdAt);
    
    NSDate *timeAgoDate = ((PFObject*)commentAry[indexPath.row]).createdAt;
    cell.messageTime.text = timeAgoDate.timeAgoSinceNow;
    
    //NSLog(@"Time Ago: %@", timeAgoDate.timeAgoSinceNow);
    //NSLog(@"Time Ago: %@", timeAgoDate.shortTimeAgoSinceNow);
    
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _detailTableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_detailTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark - keyboard move view method
- (void)clickMethof:(UITapGestureRecognizer*)recognizer{
    [self.view endEditing:YES];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    //    [_txtFiledComment resignFirstResponder];
    //    [_txtFieldName resignFirstResponder];
    
}

- (void)keyboardHeightDidChange:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.origin.y = -(keyboardSize.height);
    [self.view setFrame:frame];
}

#pragma mark - Loading Parse Data
-(void)getPhotoFile{
    //取得Header照片
    PFFile *PFPhoto = (PFFile*)_cellDictData[@"photo"];
    headerPhoto = [UIImage imageWithData:[PFPhoto getData]];
}

- (void)getRelationData {
    
    //取得目前使用者是否有參加該活動
    //PFObject *post = [PFObject objectWithoutDataWithClassName:@"TravelMatePost" objectId:_cellDictData[@"objectId"]];
    PFRelation *relation = [user relationForKey:@"joinPosts"];
    PFQuery *query = [relation query];
    query = [query whereKey:@"objectId" equalTo:_cellDictData[@"objectId"]];
    isJoin = @(query.countObjects);
    
    //是否對活動有興趣
    relation = [user relationForKey:@"interestedPosts"];
    query = [relation query];
    query = [query whereKey:@"objectId" equalTo:_cellDictData[@"objectId"]];
    isInterested = @(query.countObjects);
    
}

- (void) getCommentData {
    //留言
    //PFObject *comment = [PFObject objectWithoutDataWithClassName:COMMENT_TABLENAME objectId:_cellDictData[@"objectId"]];
    
    PFQuery *query = [PFQuery queryWithClassName:COMMENT_TABLENAME];
    [query whereKey:@"postObjectId" equalTo:_cellDictData[@"objectId"]];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"createUser.User"];
    commentAry = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
    //    commentAry = [NSMutableArray new];
    //    for(id object in [query findObjects]){
    //        NSMutableDictionary *dictComment = [NSMutableDictionary new];
    //
    //        UIImage *picture = [UIImage new];
    //        //大頭照
    //        if(object[@"createUser"][@"profilePictureSmall"]!=nil) {
    //            PFFile *PFPhoto = (PFFile*)object[@"createUser"][@"profilePictureSmall"];
    //            NSData *photoData = [PFPhoto getData];
    //            picture = [UIImage imageWithData:photoData];
    //
    //        } else {
    //            picture = [UIImage imageNamed:@"tmp-head-icon"];
    //        }
    //
    //        [dictComment setObject:picture forKey:USER_PROFILEPICTURESMALL_KEY];
    //
    //        //名字
    //        [dictComment setObject:object[TRAVELMATEPOST_POINTER_CREATEUSER_KEY][USER_DISPLAYNAME_KEY] forKey:USER_DISPLAYNAME_KEY];
    //
    //        //訊息
    //        [dictComment setObject:object[COMMENT_MESSAGE_KEY] forKey:COMMENT_MESSAGE_KEY];
    //
    //        //留言時間
    //
    //        [commentAry addObject:dictComment];
    //    }
    
}

- (void) getCountData {
    PFQuery *query = [PFQuery queryWithClassName:TRAVELMATEPOST_TABLENAME];
    [query whereKey:@"objectId" equalTo:_cellDictData[@"objectId"]];
    
    if(dictCountData == nil)
        dictCountData = [NSMutableDictionary new];
    
    for(id object in [query findObjects]) {
        [dictCountData setObject:(object[@"interestedCount"]==nil)?0:object[@"interestedCount"] forKey:@"interestedCount"];
        
        [dictCountData setObject:(object[@"commentCount"]==nil)?0:object[@"commentCount"] forKey:@"commentCount"];
        
        [dictCountData setObject:(object[@"joinCount"]==nil)?0:object[@"joinCount"] forKey:@"joinCount"];
    }
    
}

- (void) incrementWatchCount {
    
    PFObject *travelMatePost = [PFObject objectWithoutDataWithClassName:@"TravelMatePost" objectId:_cellDictData[@"objectId"]];
    [travelMatePost incrementKey:@"watchCount"];
    [travelMatePost save];
}

//更新置頂照片 和 解除霧化
- (void) didGotDatasUpdateUI {
    
    CGFloat tableViewWidth = [_cellDictData[@"tableViewWidth"] floatValue];
    headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:headerPhoto forSize:CGSizeMake(tableViewWidth, 300)];
    //置頂標題:國家城市
    headerView.headerTitleLabel.text = _cellDictData[@"countryCity"];
    [_detailTableView setTableHeaderView:headerView];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        [blurImageView removeFromSuperview];
    } else {
        [blurredView removeFromSuperview];
    }
    
    [_detailTableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - 送出留言
- (IBAction)sendMessageBtnPressed:(id)sender {
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    
    if(user) {
        [self clickMethof:nil];
        
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"發送中...";
        dispatch_queue_t sendQueue = dispatch_queue_create("Send", nil);
        dispatch_async(sendQueue, ^{
            
            PFObject *comment = [PFObject objectWithClassName:@"Comment"];
            comment[@"message"] = _messageTextField.text;
            comment[@"createUser"] = user;
            comment[@"postObjectId"] = _cellDictData[@"objectId"];
            [comment save];
            
            PFObject *travelMatePost = [PFObject objectWithoutDataWithClassName:@"TravelMatePost" objectId:_cellDictData[@"objectId"]];
            PFRelation *relation = [travelMatePost relationForKey:@"comments"];
            [relation addObject:comment];
            [travelMatePost incrementKey:@"commentCount"];
            [travelMatePost save];
            
            //取得新資料
            [self getCommentData];
            [self getCountData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageTextField.text = @"";
                [_detailTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
}

@end

