//
//  EmailLoginViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/9/14.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "SCLAlertView.h"

@interface EmailLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation EmailLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)emailLoginBtnPressed:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor customGreenColor];
    NSString *icon = @"exclamation-icon";
    NSString *title = @"登入失敗";
    NSString *subTitle = @"請檢查帳號與密碼是否有誤";

    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登入中...";
    
    [PFUser logInWithUsernameInBackground:_emailTextField.text password:_passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:EMAIL_LOGIN_PROCESS_DONE object:self];
        } else {
            //NSLog(@"%@ = ",error.description);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [alert showCustom:self image:[UIImage imageNamed:icon] color:color title:title subTitle:subTitle closeButtonTitle:@"OK" duration:0.0f];
        }
    }];
}

@end
