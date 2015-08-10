//
//  LoginViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/2.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *FBLoginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    FBLoginBtn
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)FBLoginBtnPressed:(id)sender {
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
            //} else if (user.isNew) {
            //NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook! ,%@",user.objectId);
            
            [self saveFacebookProfileData:user completion:^void(NSError *error) {
                
                if (!error) {
                    [self dismissViewControllerAnimated:true completion:nil];
                } else {
                    NSLog(@"Can't Save Data to Parse %@",error);
                }
            }];
        }
    }];
}

- (void) saveFacebookProfileData:(PFUser*)user completion:(void (^)(NSError *error))handler
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,about,email,name,gender,locale,age_range,location,link,birthday,picture.type(large)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            //            NSLog(@"result:%@",result);
            if (!error) {
                //NSLog(@"PFUser: %@ ,picture: %@",[PFUser currentUser],result [@"picture"][@"data"][@"url"]);
                
                NSURL *profilePictureURL = [NSURL URLWithString: result [@"picture"][@"data"][@"url"]];
                NSData *profilePictureData = [NSData dataWithContentsOfURL:profilePictureURL];
                [PAPUtility processFacebookProfilePictureData:profilePictureData];
                //NSLog(@"profilePictureURL: %@ ",profilePictureURL);
                
                [user setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
                [user setObject:[result objectForKey:@"name"] forKey:@"displayName"];
                
                [user setObject:[result objectForKey:@"email"]?[result objectForKey:@"email"]:[NSNull null] forKey:@"email"];
                [user setObject:[result objectForKey:@"gender"]?[result objectForKey:@"gender"]:[NSNull null] forKey:@"gender"];
                [user setObject:[result objectForKey:@"birthday"]?[result objectForKey:@"birthday"]:[NSNull null] forKey:@"birthday"];
                [user setObject:[[result objectForKey:@"location"] objectForKey:@"name"]?[[result objectForKey:@"location"] objectForKey:@"name"]:[NSNull null] forKey:@"location"];
                [user setObject:[result objectForKey:@"link"]?[result objectForKey:@"link"]:[NSNull null] forKey:@"link"];
                
                
                [user saveInBackground];
            }
            handler(error);
        }];
    }
    
}

@end
