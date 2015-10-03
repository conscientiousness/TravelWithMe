//
//  HomePostViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/9.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomePostViewController.h"

@interface HomePostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *countryCityText;
@property (weak, nonatomic) IBOutlet UITextField *startDateText;
@property (weak, nonatomic) IBOutlet UITextField *daysText;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *postScrollView;
@end

@implementation HomePostViewController
{
    UIImage *pickImage;
    PFUser *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!user) {
        user = [PFUser currentUser];
    }
    
    [_postScrollView setScrollEnabled:true];
    [_postScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 3000)];
    _postScrollView.delegate = self;
    
    //NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    
    [self initUI];
    
    //手勢控制鍵盤縮放
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethof:)];
    [self.view addGestureRecognizer:clickGesture];
    
    //鍵盤出現時發出通知
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHeightDidChange:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLayoutSubviews {

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)initUI {
    
    //Add Save Button
//    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed:)];
//    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepBtnPressed:)];
    nextStepButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = nextStepButton;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [_memoTextView.layer setBackgroundColor: [[UIColor clearColor] CGColor]];
    [_memoTextView.layer setBorderColor: [[UIColor colorWithRed:0.533 green:0.544 blue:0.562 alpha:1.000] CGColor]];
    [_memoTextView.layer setBorderWidth: 2.0];
    [_memoTextView.layer setCornerRadius:8.0f];
    [_memoTextView.layer setMasksToBounds:YES];
}

- (void)nextStepBtnPressed:(id *)sender {
    
    UIViewController *targetViewController;
    
    targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"postStep2ViewController"];
    
    [self.navigationController pushViewController:targetViewController animated:YES];
}

- (void)saveBtnPressed:(id *)sender {
    
    if(user) {
        
        MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[CustomAnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 64,64)];
        hud.labelText = @"Loading...";
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PFObject *travelMatePost = [PFObject objectWithClassName:@"TravelMatePost"];
            travelMatePost[@"countryCity"] = _countryCityText.text;
            travelMatePost[@"memo"] = _memoTextView.text;
            //travelMatePost[@"locationTag"] = _locationTagText.text;
            
            //出發日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [dateFormatter dateFromString:_startDateText.text];
            travelMatePost[@"startDate"] = startDate;
            
            //照片 UIImage imageNamed:@"pic900X640.jpg"
            
            NSData *imageData;// = [PAPUtility resizeImage:pickImage];
            
            PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"testPhoto.jpg"] data:imageData];
            travelMatePost[@"photo"] = imageFile;
            
            travelMatePost[@"days"] = [NSNumber numberWithInteger: [_daysText.text integerValue]];
            
            travelMatePost[@"createUser"] = user;
            
            [travelMatePost save];
            
            PFRelation *relation = [user relationForKey:@"travelMatePosts"];
            [relation addObject:travelMatePost];
            [user save];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });

        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  
}

#pragma mark - keyboard move view method
- (void)clickMethof:(UITapGestureRecognizer*)recognizer{
    [self.view endEditing:YES];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    //    [_txtFiledComment resignFirstResponder];
    //    [_txtFieldName resignFirstResponder];

    
}

- (void)keyboardHeightDidChange:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.origin.y = -((keyboardSize.height));
    [self.view setFrame:frame];
}

#pragma mark - textView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [_memoTextView.layer setBorderColor: [[UIColor colorWithRed:0.263 green:0.718 blue:0.608 alpha:1.000] CGColor]];
    
    
    return true;
}




@end
