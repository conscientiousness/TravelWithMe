//
//  VIPViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/7/25.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "VIPViewController.h"

@interface VIPViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet AnimationTableView *theTableView;

@property (weak, nonatomic) IBOutlet UIImageView *theHeadImage;


@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    
        
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
    
    
    UIView *headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)]; // x,y,width,height
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"我的討論", @"我的足跡", nil];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:itemArray];
    [control setFrame:CGRectMake(1.0, 15, 400, 25.0)];
    
    [control setSelectedSegmentIndex:0];
    [control setEnabled:YES];
    
    [headerView addSubview:control];
    
    [self.theTableView setTableHeaderView:headerView];
    
    
    //大頭照圓形遮罩
    _theHeadImage.layer.cornerRadius =_theHeadImage.frame.size.width / 2;
    _theHeadImage.layer.borderWidth = 2.0f;
    _theHeadImage.layer.borderColor = [UIColor boyPhotoBorderColor].CGColor;
    _theHeadImage.clipsToBounds = YES;
    
    
}

    

    
    -(void)viewDidLayoutSubviews {
        [super viewDidLayoutSubviews];
        self.theTableView.contentInset = UIEdgeInsetsMake(self.theImageView.frame.size.height-40, 0, 0, 0);
    }
    
    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        
        if (scrollView.contentOffset.y < self.theImageView.frame.size.height*-1 ) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.theImageView.frame.size.height*-1)];
        }
    }
    
    
    
    
#pragma mark - UITableViewDataSource
    
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return 100;
    }
    
    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell;
        
    }
    
    @end
    
    
    
