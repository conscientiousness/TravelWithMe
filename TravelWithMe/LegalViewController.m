//
//  LegalViewController.m
//  TravelWithMe
//
//  Created by Hank on 2015/8/21.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()
{
    NSArray *legaltextviewAry;
}
@property (weak, nonatomic) IBOutlet UITextView *legalTextview;

@end

@implementation LegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"讀取中...";
    
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading", nil);
    dispatch_async(loadingQueue, ^{
        [self getdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            _legalTextview.text = legaltextviewAry[0][@"Text"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    //大頭照圓形遮罩
    _legalTextview.layer.cornerRadius =_legalTextview.frame.size.width / 90;
    _legalTextview.layer.borderWidth = 1.0f;
    _legalTextview.layer.borderColor = [UIColor colorWithRed:0.255 green:0.698 blue:0.592 alpha:1.000].CGColor;
    //_policyTextview.clipsToBounds = YES;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Load Parse Data

- (void) getdata{
    PFQuery *policytext = [PFQuery queryWithClassName:@"Legal"];
    
    legaltextviewAry = [[NSArray alloc] initWithArray:[policytext findObjects]];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)backBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
