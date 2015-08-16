//
//  HomePostViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/9.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomePostViewController.h"

@interface HomePostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *countryCityText;
@property (weak, nonatomic) IBOutlet UITextField *startDateText;
@property (weak, nonatomic) IBOutlet UITextField *daysText;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;

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
    
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    //
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
    self.navigationItem.rightBarButtonItem = nextStepButton;

    self.view.backgroundColor = [UIColor homeCellbgColor];
    
    [_memoTextView.layer setBackgroundColor: [[UIColor clearColor] CGColor]];
    [_memoTextView.layer setBorderColor: [[UIColor colorWithRed:0.533 green:0.544 blue:0.562 alpha:1.000] CGColor]];
    [_memoTextView.layer setBorderWidth: 1.0];
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
        hud.labelText = @"發送中...";
        
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
            
            NSData *imageData = [PAPUtility resizeImage:pickImage];
            
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

#pragma mark - textView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [_memoTextView.layer setBorderColor: [[UIColor colorWithRed:0.263 green:0.718 blue:0.608 alpha:1.000] CGColor]];
    return true;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得使用者拍攝的照片
    pickImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    //縮圖
    pickImage = [pickImage thumbnailImage:500 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    // 存檔
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pictureBtnPressed:(id)sender {
    
    UIAlertController * alertController = [UIAlertController new];//[UIAlertController alertControllerWithTitle:@"照相機" message:@"gg" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 先檢查裝置是否配備相機
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            // 設定相片來源為裝置上的相機
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 設定imagePicker的delegate為ViewController
            imagePicker.delegate = self;
            //開起相機拍照界面
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"選擇照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UIPopoverPresentationController *popover;
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        
        // 設定相片的來源為行動裝置內的相本
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        
        // 設定顯示模式為popover
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        popover = imagePicker.popoverPresentationController;
        // 設定popover視窗與哪一個view元件有關連
        popover.sourceView = sender;
        // 以下兩行處理popover的箭頭位置
        // popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    

    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //NSLog(@"cancel");
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
