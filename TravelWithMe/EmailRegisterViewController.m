//
//  EmailRegisterViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/9/14.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "SCLAlertView.h"

@interface EmailRegisterViewController ()
{
    NSString *title;
    NSString *subTitle;
    BOOL errorflag;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@end

@implementation EmailRegisterViewController


- (IBAction)registerBtnPressed:(id)sender {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor customGreenColor];
    NSString *icon = @"exclamation-icon";
    errorflag = NO;
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"註冊中...";
    
    PFUser *user = [PFUser user];
    user.username = _emailTextField.text;
    user.password = _passwordTextField.text;
    user[USER_DISPLAYNAME_KEY] = _displayNameTextField.text;
    
    if([self validateInputDatas]) {
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"head-image"]);
                [PAPUtility processEmailAccountProfilePictureData:imageData];
                //pop root vc and dismiss
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:EMAIL_LOGIN_PROCESS_DONE object:self];
            }
            else {
                NSInteger errorCode = [(NSNumber*)[error userInfo][@"code"] integerValue];
                
                switch (errorCode) {
                    case 202:
                        title = @"帳號存在";
                        subTitle = @"此Email已經註冊了喔";
                        errorflag = YES;
                        break;
                    case 100:
                        title = @"連線";
                        subTitle = @"網路有問題喔";
                        errorflag = YES;
                        break;
                    default:
                        title = @"Sorry";
                        subTitle = @"註冊失敗>_<";
                        errorflag = YES;
                        break;
                }
            }
            [alert showCustom:self image:[UIImage imageNamed:icon] color:color title:title subTitle:subTitle closeButtonTitle:@"OK" duration:0.0f];
        }];
    }else{
        [alert showCustom:self image:[UIImage imageNamed:icon] color:color title:title subTitle:subTitle closeButtonTitle:@"OK" duration:0.0f];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)validateInputDatas {
    BOOL flag = YES;
    
    
    if([_emailTextField.text isEqualToString:@""]||_emailTextField.text==nil) {
        
        title = @"Email";
        subTitle = @"沒輸入喔";
        flag = NO;

    }
    else if([_passwordTextField.text isEqualToString:@""]||_passwordTextField.text==nil) {
        
        title = @"密碼";
        subTitle = @"沒輸入喔";
        flag = NO;
        
    }
    else if([_passwordTextField.text isEqualToString:@""]||_passwordTextField.text==nil) {
        
        title = @"暱稱";
        subTitle = @"沒輸入喔";
        flag = NO;
        
    }
    else if(![self validateEmail:_emailTextField.text]) {
        // user entered invalid email address
        
        title = @"Email";
        subTitle = @"格式錯誤喔";
        flag = NO;
    }
    
    return flag;
}


- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
@end
