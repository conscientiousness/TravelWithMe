//
//  LoginViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/2.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PolicyViewController.h"
#import "Singleton.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *FBLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginBtn;
@property (nonatomic, strong) AVPlayer *avplayer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[Singleton sharedInstance];
    //Not affecting background music playing
    
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login-background-video" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.videoView.layer addSublayer:avPlayerLayer];
    [self.view.layer insertSublayer:avPlayerLayer below:self.videoView.layer];
//[self.view insertSubview:blurView belowSubview:_infoView];
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(emailLoginDone)
                                                name:EMAIL_LOGIN_PROCESS_DONE
                                              object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // using dispatch_after
    //dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3 * NSEC_PER_SEC));
    //dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.avplayer play];
    //});
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)emailLoginDone{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)FBLoginBtnPressed:(id)sender {
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[CustomAnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 64,64)];
    hud.labelText = @"Loading...";
    
    dispatch_queue_t loginFacebookQueue = dispatch_queue_create("loginFacebookQueue", nil);
    dispatch_async(loginFacebookQueue, ^{

        [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile"] block:^(PFUser *user, NSError *error) {
            if (!user) {
                //NSLog(@"Uh oh. The user cancelled the Facebook login.");
                
                //} else if (user.isNew) {
                //NSLog(@"User signed up and logged in through Facebook!");
            } else {
                //NSLog(@"User logged in through Facebook! ,%@",user.objectId);
                
                [self saveFacebookProfileData:user completion:^void(NSError *error) {
                    //NSLog(@"profilePictureURL: %@ ",user);
                    if (!error) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    } else {
                        //NSLog(@"Can't Save Data to Parse %@",error);
                    }
                }];
            }
        }];
    });
}

- (void) saveFacebookProfileData:(PFUser*)user completion:(void (^)(NSError *error))handler
{
    //@"fields":@"id,email,name,gender,locale,age_range,location,link,birthday,picture.type(large)"
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,gender,picture.type(large)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            //            NSLog(@"result:%@",result);
            if (!error) {
                //NSLog(@"PFUser: %@ ,picture: %@",[PFUser currentUser],result [@"picture"][@"data"][@"url"]);
                
                NSURL *profilePictureURL = [NSURL URLWithString: result [@"picture"][@"data"][@"url"]];
                NSData *profilePictureData = [NSData dataWithContentsOfURL:profilePictureURL];
                [PAPUtility processFacebookProfilePictureData:profilePictureData];
                //NSLog(@"profilePictureURL: %@ ",result);
                
                [user setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
                [user setObject:[result objectForKey:@"name"] forKey:@"displayName"];
                
                //[user setObject:[result objectForKey:@"email"]?[result objectForKey:@"email"]:[NSNull null] forKey:@"email"];
                [user setObject:[result objectForKey:@"gender"]?[result objectForKey:@"gender"]:[NSNull null] forKey:@"gender"];
                [user setObject:[result objectForKey:@"birthday"]?[result objectForKey:@"birthday"]:[NSNull null] forKey:@"birthday"];
                //[user setObject:[[result objectForKey:@"location"] objectForKey:@"name"]?[[result objectForKey:@"location"] objectForKey:@"name"]:[NSNull null] forKey:@"location"];
                [user setObject:[result objectForKey:@"link"]?[result objectForKey:@"link"]:[NSNull null] forKey:@"link"];
                user[@"installation"] = [PFInstallation currentInstallation];
                
                [user saveInBackground];
            }
            handler(error);
        }];
    }
    
}
- (IBAction)policyBtnPressed:(id)sender {
    
    UIStoryboard *targetStoryboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    PolicyViewController *targetViewController = [targetStoryboard instantiateViewControllerWithIdentifier:@"policy"];
    
    [self presentViewController:targetViewController animated:YES completion:^{
        
    }];
    
}



@end
