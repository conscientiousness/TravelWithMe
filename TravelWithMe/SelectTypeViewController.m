//
//  SelectTypeViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/24.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "MapViewController.h"
#import "VBFPopFlatButton.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_HEIGHT self.view.frame.size.height
#define VIEW_WIDTH self.view.frame.size.width

@interface SelectTypeViewController ()
{
    UIDynamicAnimator *animator;
    UIDynamicAnimator *animator2;
    UIDynamicAnimator *animator3;
    NSDictionary *userInfoDict;
}
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;
@property (nonatomic, strong) UIButton *foodBtn;
@property (nonatomic, strong) UIButton *landscapeBtn;
@property (nonatomic, strong) UIButton *peopleBtn;

@end

@implementation SelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAnimator];
    [self initTypeBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(MAP_FLAT_BTN_CGRECTMAKE)
                                                         buttonType:buttonCloseType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    self.flatRoundedButton.roundBackgroundColor = [UIColor redColor];
    self.flatRoundedButton.lineThickness = 3;
    self.flatRoundedButton.tintColor = [UIColor whiteColor];
    [self.flatRoundedButton addTarget:self
                               action:@selector(flatRoundedButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
    
    [self setBtnDynamicAnimator];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化動態行為
- (void) initAnimator {
    animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    animator2 = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    animator3 = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

#pragma mark - 初始化類別按鈕
- (void) initTypeBtn {
    
    _foodBtn = [[UIButton alloc] initWithFrame:CGRectMake(FOOT_BTN_CGRECTMAKE)];
    [_foodBtn setBackgroundColor:[UIColor clearColor]];
    [_foodBtn setImage:[UIImage imageNamed:@"food-icon"] forState:UIControlStateNormal];
    [_foodBtn addTarget:self action:@selector(foodBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_foodBtn];
    
    _landscapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(LANSCAPE_BTN_CGRECTMAKE)];
    [_landscapeBtn setImage:[UIImage imageNamed:@"landscape-icon"] forState:UIControlStateNormal];
    [_landscapeBtn addTarget:self action:@selector(landscapePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_landscapeBtn];
    
    _peopleBtn = [[UIButton alloc] initWithFrame:CGRectMake(PEOPLE_BTN_CGRECTMAKE)];
    [_peopleBtn setImage:[UIImage imageNamed:@"people-icon"] forState:UIControlStateNormal];
    [_peopleBtn addTarget:self action:@selector(peoplePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_peopleBtn];
}

#pragma mark - 設定類別按鈕動態行為
- (void) setBtnDynamicAnimator {
    
    //給予按鈕撲向動態
    UISnapBehavior *foodBtnSnapBehavior = [[UISnapBehavior alloc]initWithItem:_foodBtn snapToPoint:CGPointMake(FOOD_BTN_SNAP_BEHAVIOR_CGPOINT)];
    foodBtnSnapBehavior.damping = 0.7;
    [animator addBehavior:foodBtnSnapBehavior];
    
    UISnapBehavior *landscapeBtnSnapBehavior = [[UISnapBehavior alloc]initWithItem:_landscapeBtn snapToPoint:CGPointMake(LANSCAPE_BTN_SNAP_BEHAVIOR_CGPOINT)];
    landscapeBtnSnapBehavior.damping = 0.7;
    [animator2 addBehavior:landscapeBtnSnapBehavior];
    
    UISnapBehavior *peopleBtnSnapBehavior = [[UISnapBehavior alloc]initWithItem:_peopleBtn snapToPoint:CGPointMake(PEOPLE_BTN_SNAP_BEHAVIOR_CGPOINT)];
    peopleBtnSnapBehavior.damping = 0.7;
    [animator3 addBehavior:peopleBtnSnapBehavior];
}


#pragma mark - 點選取消按鈕
-(void) flatRoundedButtonPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:TOP_CHILD_DISMISSED_NOTIFICATION object:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - 點選類別按鈕

-(void) foodBtnPressed:(UIButton *)button {
    
    [self willPrestentToMapPost:@"food"];
}

-(void) landscapePressed:(UIButton *)button {
    
    [self willPrestentToMapPost:@"landscape"];
}

-(void) peoplePressed:(UIButton *)button {
    
    [self willPrestentToMapPost:@"people"];
}

// dismiss後在present到po文畫面
-(void) willPrestentToMapPost:(NSString*)typeString {
    //傳回所選類別
    if(userInfoDict==nil)
        userInfoDict = [NSDictionary new];
    
    userInfoDict = @{MAPPOST_TYPE_KEY:typeString};
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_TO_MAPPOSTVIEW_NOTIFICATION object:self userInfo:userInfoDict];
}


-(void)dealloc{
    //NSLog(@"dealloc is YES");
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
