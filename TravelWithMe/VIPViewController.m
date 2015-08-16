//
//  VIPViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "VIPViewController.h"
#import "CExpandHeader.h" //import 第三方 CExpandHeader

#define CExpandContentOffset @"contentOffset"
#define AFTER(s) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)),    dispatch_get_main_queue(), ^
#define KNeedSaveOffset NO

@interface VIPViewController ()




@end

@implementation VIPViewController
{

__weak IBOutlet UITableView *myViptableView;
__weak UIImageView *_expandView;

CExpandHeader *_headerPhoto;

UIView* _headBg;
UIView* _headView;
UIView *_sectionView;

int index;
UITableView* _tableView1;
UITableView* _tableView2;
UIView* lineView;
CGPoint tableOffset1;
CGPoint tableOffset2;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    
    //  build image 位置
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    
    //  image Name
    [imageView setImage:[UIImage imageNamed:@"22.png"]];
    
    
    // build section view 位置和顏色
    _sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _sectionView.backgroundColor=[UIColor colorWithRed: 0.9897 green: 0.8915 blue: 0.7872 alpha: 1.0];
    
    [self.view addSubview:imageView];
    //  _headBg=imageView;
    //	_headBg.contentMode= UIViewContentModeScaleAspectFill;
    //	_headBg.clipsToBounds = YES;
    
    // build 顏色透明位置
    _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    _headView.backgroundColor=[UIColor clearColor];
    
    
    UILabel* lab=[[UILabel alloc] initWithFrame:_headView.bounds];
    lab.text=@"我的頁面";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.backgroundColor=[UIColor clearColor];
    [_headView addSubview:lab];
    
    
    //	[_tableView addObserver:self forKeyPath:CExpandContentOffset options:NSKeyValueObservingOptionNew context:nil];
    myViptableView.backgroundColor=[UIColor clearColor];
    [self.view bringSubviewToFront:myViptableView];
    
    // add to listen observer to control imageView change with table scroll
    _headerPhoto = [CExpandHeader expandWithScrollView:myViptableView expandView:imageView];
    
    // build 2 sub table view
    _tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _tableView1.delegate=self;
    _tableView1.dataSource=self;
    
    _tableView2=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    
    // build tabbar 2 btn
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(0, 0, _sectionView.frame.size.width/2, _sectionView.frame.size.height);
    [btn setTitle:@"我的討論" forState:UIControlStateNormal];
    [btn addTarget:self	action:@selector(changeToTable1) forControlEvents:UIControlEventTouchUpInside];
    [_sectionView addSubview:btn];
    
    btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(_sectionView.frame.size.width/2, 0, _sectionView.frame.size.width/2, _sectionView.frame.size.height);
    [btn setTitle:@"我的足跡" forState:UIControlStateNormal];
    [btn addTarget:self	action:@selector(changeToTable2) forControlEvents:UIControlEventTouchUpInside];
    [_sectionView addSubview:btn];
    
    lineView=[[UIView alloc] initWithFrame:CGRectMake(0, _sectionView.frame.size.height-2, _sectionView.frame.size.width/2, 2)];
    lineView.backgroundColor=[UIColor colorWithRed: 0.2894 green: 0.7154 blue: 0.6361 alpha: 1.0];
    [_sectionView addSubview:lineView];
    
    // set table height
    _tableView1.frame=CGRectMake(0, 0, 320, 44*20);
    _tableView2.frame=CGRectMake(0, 0, 320, 44*20);
    _tableView1.scrollEnabled=NO;
    _tableView2.scrollEnabled=NO;
    myViptableView.contentSize=CGSizeMake(320, _tableView1.frame.size.height+40); // todo
}

-(void) changeToTable1
{
    NSLog(@"changeToTable1");
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
    NSLog(@"changeToTable2");
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
    else if(tableView==_tableView1 || tableView==_tableView2)
    {
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    if(tableView==_tableView1 || tableView==_tableView2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.textLabel.textColor=(tableView==_tableView1 ? [UIColor redColor] : [UIColor blackColor]);
        [cell.textLabel setText:[NSString  stringWithFormat:@"this is row : %ld",(long)indexPath.row]];
    }
    else if(tableView==myViptableView)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(index==0)
            [cell.contentView addSubview:_tableView1];
        else
            [cell.contentView addSubview:_tableView2];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==myViptableView)
        return _tableView1.frame.size.height;
    
    return 44.f;
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

@end
