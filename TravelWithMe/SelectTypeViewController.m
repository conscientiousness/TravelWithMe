//
//  SelectTypeViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/24.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "VBFPopFlatButton.h"
#import "MapPostViewController.h"
#import <QuartzCore/QuartzCore.h>

#define VIEW_HEIGHT self.view.frame.size.height
#define VIEW_WIDTH self.view.frame.size.width

@interface SelectTypeViewController ()
{
    UIDynamicAnimator *animator;
    UIDynamicAnimator *animator2;
    UIDynamicAnimator *animator3;
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
    [_foodBtn setImage:[UIImage imageNamed:@"interested-icon"] forState:UIControlStateNormal];
    [_foodBtn addTarget:self action:@selector(foodBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_foodBtn];
    
    _landscapeBtn = [[UIButton alloc] initWithFrame:CGRectMake(LANSCAPE_BTN_CGRECTMAKE)];
    [_landscapeBtn setImage:[UIImage imageNamed:@"comment-icon"] forState:UIControlStateNormal];
    [_landscapeBtn addTarget:self action:@selector(landscapePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_landscapeBtn];
    
    _peopleBtn = [[UIButton alloc] initWithFrame:CGRectMake(PEOPLE_BTN_CGRECTMAKE)];
    [_peopleBtn setImage:[UIImage imageNamed:@"join-icon"] forState:UIControlStateNormal];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isDismiss" object:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - 點選類別按鈕

-(void) foodBtnPressed:(UIButton *)button {
    MapPostViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapPostViewController"];
    
    targetViewController.block = ^void(BOOL isSave){
        if(isSave)
           [self dismissViewControllerAnimated:NO completion:nil];
    };
    //targetViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:targetViewController animated:NO completion:nil];
}

-(void) landscapePressed:(UIButton *)button {
    
}

-(void) peoplePressed:(UIButton *)button {
    
}

-(void)dealloc{
    NSLog(@"YES");
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
