//
//  favoriteMainViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/8/11.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "favoriteMainViewController.h"
#import "favoriteTableViewController.h"
#import "followTableViewController.h"
#import "UIColors.h"
@interface favoriteMainViewController ()
{
    PFUser *user;
    favoriteTableViewController *vc1;
    followTableViewController *vc2;
    NSMutableArray *arrayDatas;
}
@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UIView *followView;
@end

@implementation favoriteMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (!user) {
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    
    UIViewController *targetViewController;
    UIStoryboard *storyboard;
    if(!user)
    { //抓不到user權限，導向LOGIN畫面
        
        storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self presentViewController:targetViewController animated:YES completion:nil];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!user) {
        user = [PFUser currentUser];
    }
    
    if([PFUser currentUser]==nil) {
        user = nil;
    }
    
    
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
    
    arrayDatas = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    
    //每次上拉查詢增加筆數
    //dataCount = [NSNumber numberWithInt:[dataCount intValue] + 3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn:(UISegmentedControl*)sender {
    
    NSInteger targetIndex = sender.selectedSegmentIndex;
    switch (targetIndex) {
        case 0:
            self.favoriteView.hidden= YES;
            self.followView.hidden= NO;
           
            break;
            
        case 1:
            self.favoriteView.hidden= NO;
            self.followView.hidden= YES;
            
         
            break;
    }
    
    
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
