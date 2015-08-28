//
//  VIPViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "VIPViewController.h"
#import "CExpandHeader.h" //import 第三方 CExpandHeader
#import "VIPMyActivityTableViewCell.h"

#define CExpandContentOffset @"contentOffset"
#define AFTER(s) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)),    dispatch_get_main_queue(), ^
#define KNeedSaveOffset NO
#define VIPMYACTIVITYCELL_HEIGHT 80.0

@interface VIPViewController ()

@end

@implementation VIPViewController
{
    __weak IBOutlet UITableView *myViptableView;
    __weak UIImageView *_expandView;

    CExpandHeader *_headerPhoto;
    UIImageView *imageView;

    UIView* _headBg;
    UIView* _headView;
    UIView *_sectionView;

    int index;
    UITableView *_tableView1;
    UITableView *_tableView2;
    UIView* lineView;
    CGPoint tableOffset1;
    CGPoint tableOffset2;
    
    UILabel *displayNameLabel;
    UIImageView *headPhotoImageView;
    
    NSMutableArray *myActivityArrayDatas;
    NSMutableArray *myFootprintArrayDatas;
    
    PFUser *user;
}


//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //判斷從設定頁或是其他地方跳轉過來
    if(_userObjectId==nil || [_userObjectId isEqualToString:@""])
        user = [PFUser currentUser];
    else
        user = [PFUser objectWithoutDataWithObjectId:_userObjectId];
    
    [self prepareTableViewUI];
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", nil);
    dispatch_async(loadingQueue, ^{
        [self getTravelMatePostDatas];
        [self getFootprintDatas];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tableView1.frame=CGRectMake(0, 0, self.view.frame.size.width, VIPMYACTIVITYCELL_HEIGHT*myActivityArrayDatas.count);
            _tableView2.frame=CGRectMake(0, 0, self.view.frame.size.width, VIPMYACTIVITYCELL_HEIGHT*myFootprintArrayDatas.count);
            [myViptableView reloadData];
            [_tableView1 reloadData];
            [_tableView2 reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    //self.navigationController.navigationBarHidden=YES;
}

- (void) prepareTableViewUI {
    
    
    //  build image 位置
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200 + self.navigationController.navigationBar.bounds.size.height)];
    //  image Name
    [imageView setImage:[UIImage imageNamed:@"my_pages.png"]];

    
    // build section view 位置和顏色
    _sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _sectionView.backgroundColor=[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0];
    
    [self.view addSubview:imageView];
    //  _headBg=imageView;
    //	_headBg.contentMode= UIViewContentModeScaleAspectFill;
    //	_headBg.clipsToBounds = YES;
    
    // build 顏色透明位置
    _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    _headView.backgroundColor=[UIColor clearColor];
    
    //姓名Lable位置
    CGRect displayNameFrame = _headView.frame;
    displayNameFrame.origin.y += 50;
    
    displayNameLabel=[[UILabel alloc] initWithFrame:displayNameFrame];
    displayNameLabel.text = user[USER_DISPLAYNAME_KEY];
    displayNameLabel.textColor = [UIColor whiteColor];
    displayNameLabel.textAlignment=NSTextAlignmentCenter;
    displayNameLabel.backgroundColor=[UIColor clearColor];
    [_headView addSubview:displayNameLabel];
    
    //大頭照
    CGRect headPhotoFrame = CGRectMake(_headView.bounds.size.width/2 - 32, _headView.bounds.size.height/2 -32, 64, 64);
    headPhotoImageView = [[UIImageView alloc] initWithFrame:headPhotoFrame];
    [headPhotoImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    //圓角處理
    headPhotoImageView.layer.cornerRadius = headPhotoImageView.frame.size.width / 2;
    headPhotoImageView.layer.borderWidth = 3.0f;
    UIColor *genderColor;
    if([user[USER_GENDER_KEY] isEqualToString:@"male"]) {
        genderColor = [UIColor boyPhotoBorderColor];
    } else if([user[USER_GENDER_KEY] isEqualToString:@"female"]) {
        genderColor = [UIColor girlPhotoBorderColor];
    } else {
        genderColor = [UIColor customGreenColor];
    }
    headPhotoImageView.layer.borderColor = genderColor.CGColor;
    headPhotoImageView.clipsToBounds = YES;
    
    PFFile *photo = (PFFile *)user[USER_PROFILEPICTUREMEDIUM_KEY];
    [headPhotoImageView sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"intrested-icon"]];
    //[headPhotoImageView setImage:[UIImage imageNamed:@"intrested-icon"]];
    [_headView addSubview:headPhotoImageView];
    
    
    
    //	[_tableView addObserver:self forKeyPath:CExpandContentOffset options:NSKeyValueObservingOptionNew context:nil];
    myViptableView.backgroundColor=[UIColor clearColor];
    [self.view bringSubviewToFront:myViptableView];
    
    // add to listen observer to control imageView change with table scroll
    _headerPhoto = [CExpandHeader expandWithScrollView:myViptableView expandView:imageView];
    
    // build 2 sub table view
    _tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 480)];
    //_tableView1 = [UITableView new];
    _tableView1.delegate=self;
    _tableView1.dataSource=self;
    
    _tableView2=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 480)];
    //_tableView2 = [UITableView new];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    
    // build tabbar 2 btn
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(0, 0, _sectionView.frame.size.width/2, _sectionView.frame.size.height);
    [btn setTitle:@"活動" forState:UIControlStateNormal];
    [btn addTarget:self	action:@selector(changeToTable1) forControlEvents:UIControlEventTouchUpInside];
    [_sectionView addSubview:btn];
    
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(_sectionView.frame.size.width/2, 0, _sectionView.frame.size.width/2, _sectionView.frame.size.height);
    [btn setTitle:@"足跡" forState:UIControlStateNormal];
    [btn addTarget:self	action:@selector(changeToTable2) forControlEvents:UIControlEventTouchUpInside];
    [_sectionView addSubview:btn];
    
    lineView=[[UIView alloc] initWithFrame:CGRectMake(0, _sectionView.frame.size.height-2, _sectionView.frame.size.width/2, 2)];
    lineView.backgroundColor=[UIColor customGreenColor];
    [_sectionView addSubview:lineView];
    
    // set table height
    //NSLog(@"%ld",arrayDatas.count);
    _tableView1.frame=CGRectMake(0, 0, self.view.frame.size.width, VIPMYACTIVITYCELL_HEIGHT*myActivityArrayDatas.count);
    _tableView2.frame=CGRectMake(0, 0, self.view.frame.size.width, VIPMYACTIVITYCELL_HEIGHT*myFootprintArrayDatas.count);
    _tableView1.scrollEnabled=NO;
    _tableView2.scrollEnabled=NO;
    myViptableView.contentSize=CGSizeMake(self.view.frame.size.width, _tableView1.frame.size.height+40); // todo
    
    //關閉分隔線
    [_tableView1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [myViptableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //設定背景色
    _tableView1.backgroundColor = [UIColor whiteColor];
    _tableView2.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
}

-(void) changeToTable1
{
    //NSLog(@"changeToTable1");
    if(index==0)
        return;
    
    tableOffset2=myViptableView.contentOffset;
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.2];
    lineView.frame=CGRectMake(0, _sectionView.frame.size.height-2, _sectionView.frame.size.width/2, 2);
    [UIView commitAnimations];
    
    AFTER(0.2)
    {
        index=0;
        [myViptableView reloadData];
        
        if(KNeedSaveOffset)
            myViptableView.contentOffset=tableOffset1;
    });
}

-(void) changeToTable2
{
    //NSLog(@"changeToTable2");
    
    
    
    if(index==2)
        return;
    
    tableOffset1=myViptableView.contentOffset;
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.2];
    lineView.frame=CGRectMake(_sectionView.frame.size.width/2, _sectionView.frame.size.height-2, _sectionView.frame.size.width/2, 2);
    [UIView commitAnimations];
    
    AFTER(0.2)
    {
        index=2;
        [myViptableView reloadData];
        [_tableView2 reloadData];
    
        if(KNeedSaveOffset)
            myViptableView.contentOffset=tableOffset2;
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==myViptableView)
    {
        if(section==0)
            return 0;
        
        return 1; // return table1 or table2
    }
    else if(tableView==_tableView1)
    {
        return myActivityArrayDatas.count;
    }
    else if(tableView==_tableView2)
    {
        return myFootprintArrayDatas.count;
    }
        
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    NSString *identifier;
    NSString *nibName;
    UINib *nib;
    //NSLog(@"%ld",indexPath.row);
    
    if(tableView==_tableView1)
    {
        identifier = @"cell";
        nibName = @"VIPMyActivityTableViewCell";
        nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        
       VIPMyActivityTableViewCell *myActivityCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        myActivityCell.myActivityCountryCityLabel.text = myActivityArrayDatas[indexPath.row][TRAVELMATEPOST_COUNTRYCITY_KEY];
        
        myActivityCell.myActivityStartDate.text = myActivityArrayDatas[indexPath.row][TRAVELMATEPOST_STARTDATE_KEY];

        myActivityCell.myActivityMemo.text = myActivityArrayDatas[indexPath.row][TRAVELMATEPOST_MEMO_KEY];
        
        PFFile *photo = (PFFile *)myActivityArrayDatas[indexPath.row][TRAVELMATEPOST_SMALLPHOTO_KEY];
        [myActivityCell.myActivityShareSmallPhoto sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"intrested-icon"]];
        
        myActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return myActivityCell;
        
        //if (!cell)
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    else if(tableView==_tableView2)
    {
        identifier = @"cell";
        nibName = @"VIPMyActivityTableViewCell";
        nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        
        
        VIPMyActivityTableViewCell *myFootprintCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        myFootprintCell.myActivityCountryCityLabel.text = myFootprintArrayDatas[indexPath.row][MAPPOST_COUNTRY_KEY];
        
        myFootprintCell.myActivityStartDate.text = myFootprintArrayDatas[indexPath.row][MAPPOST_LOCALITY_KEY];
        
        myFootprintCell.myActivityMemo.text = myFootprintArrayDatas[indexPath.row][MAPPOST_MEMO_KEY];
        
        PFFile *photo = (PFFile *)myFootprintArrayDatas[indexPath.row][MAPPOST_SMALLPHOTO_KEY];
        [myFootprintCell.myActivityShareSmallPhoto sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"intrested-icon"]];
        
        myFootprintCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return myFootprintCell;
    }
    
    else if(tableView==myViptableView)
    {
        identifier = @"cell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(index==0) {
            
            [cell.contentView addSubview:_tableView1];
        }
        else
        {
            _tableView2.frame=CGRectMake(0, 0, self.view.frame.size.width, VIPMYACTIVITYCELL_HEIGHT*myFootprintArrayDatas.count);
            myViptableView.contentSize=CGSizeMake(self.view.frame.size.width, _tableView2.frame.size.height+235);
            NSLog(@"%f",VIPMYACTIVITYCELL_HEIGHT*myFootprintArrayDatas.count);
            [cell.contentView addSubview:_tableView2];
        }
        
    }
    
    return cell;
}

/*
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
*/

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==myViptableView)
        return _tableView1.frame.size.height;
    
    return VIPMYACTIVITYCELL_HEIGHT;
}

// for add a section
-(CGFloat) tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==myViptableView)
    {
        if(section==0)
            return _headView.frame.size.height;
        
        return _sectionView.frame.size.height;
    }
    
    return 0;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    if(tableView==myViptableView)
        return 2;
    
    return 1;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView==myViptableView)
    {
        if(section==0)
            return _headView;
        
        return _sectionView;
    }
    
    return nil;
}

#pragma mark - 取得USER徵求旅伴所有貼文

- (void) getTravelMatePostDatas
{
    //userObjectId = @"fWcSONXdmc";
                          
    PFRelation *relation = [user relationForKey:@"travelMatePosts"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    //query.limit = 3;
    
    //if(arrayDatas==nil)
        //arrayDatas = [NSMutableArray new];
    
    myActivityArrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
    //每次上拉查詢增加筆數
    //dataCount = [NSNumber numberWithInt:[dataCount intValue] + 3];
}

#pragma mark - 取得USER地圖足跡所有貼文
- (void) getFootprintDatas
{
    
    //userObjectId = @"iSoRfCRWKu";

    PFRelation *relation = [user relationForKey:@"mapPosts"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"createdAt"];
    //query.limit = 3;
    
    //if(arrayDatas==nil)
    //arrayDatas = [NSMutableArray new];
    
    myFootprintArrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
    //每次上拉查詢增加筆數
    //dataCount = [NSNumber numberWithInt:[dataCount intValue] + 3];
}


@end
