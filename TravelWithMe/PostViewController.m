//
//  PostViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/8/17.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "PostViewController.h"
#import "CountryCityTableViewCell.h"
#import "StartDateDaysTableViewCell.h"
#import "SharePhotoTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define POSTVIEWCONTROLLER_COUNTRYCITY_KEY @"countryCity"
#define POSTVIEWCONTROLLER_STARTDATE_KEY @"srartDate"
#define POSTVIEWCONTROLLER_DAYS_KEY @"days"
#define POSTVIEWCONTROLLER_MEMO_KEY @"memo"
#define POSTVIEWCONTROLLER_PHOTO_KEY @"photo"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 4

#define TEXTFIELD_COUNTRYCITY_TAG 1000
#define TEXTFIELD_STARTDATE_TAG 2000
#define TEXTFIELD_DAYS_TAG 2001
#define IMAGEVIEW_SHAREPHOTO_TAG 3000
#define TEXTVIEW_MEMO_TAG 4000

@interface PostViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage *pickImage;
    PFUser *user;
    NSMutableDictionary *datas;
    UIImagePickerController *imagePicker;
    UIImageView *selectedImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@end

@implementation PostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBarController.tabBar setHidden:YES];
    //_postTableView.frame.size.height = self.tabBarController.tabBar.frame.size.height;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect tableViewNewFrame = _postTableView.frame;
    tableViewNewFrame.size.height += self.tabBarController.tabBar.frame.size.height;
    [_postTableView setFrame:tableViewNewFrame];
}

- (void)initUI {
    
    //Add Save Button
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed:)];
    //    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"發佈" style:UIBarButtonItemStylePlain target:self action:@selector(publishBtnPressed:)];
    nextStepButton.enabled = YES;
    self.navigationItem.rightBarButtonItem = nextStepButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)publishBtnPressed:(id *)sender {
    [self.view endEditing:YES];
//    NSIndexPath *indexPath;
//    UITableViewCell *cell;
//    
//    for(int i=0;i<NUMBER_OF_ROWS;i++) {
//        
//        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        cell = [_postTableView cellForRowAtIndexPath:indexPath];
//        
//        for (UIView *subView in cell.contentView.subviews)
//        {
//            if ([subView isKindOfClass:[UITextField class]])
//            {
//                UITextField *txtField = (UITextField *)subView;
//                NSLog(@"%@",txtField.text);
//            }
//        }
//        
//    }
    
    //[cell viewWithTag:];
    
    //NSLog(@"text1 = %@ ,text2 = %@ ,text3 = %@",((UITextField*)datas[POSTVIEWCONTROLLER_COUNTRYCITY_KEY]).text,((UITextField*)datas[POSTVIEWCONTROLLER_STARTDATE_KEY]).text,((UITextField*)datas[POSTVIEWCONTROLLER_DAYS_KEY]).text);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table View Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(datas == nil) {
        datas = [NSMutableDictionary new];
    }
    
    NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"cell1";
    } else if (indexPath.row == 1){
        identifier = @"cell2";
    } else if (indexPath.row == 2){
        identifier = @"cell3";
    } else if (indexPath.row == 3){
        identifier = @"cell4";
    }
   
    if (indexPath.row == 0) {
        CountryCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell.CountryCityTextField setTag:TEXTFIELD_COUNTRYCITY_TAG];
        
        return cell;
        
    } else if (indexPath.row == 1) {
    
        StartDateDaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        [cell.startDateTextField setTag:TEXTFIELD_STARTDATE_TAG];
        [cell.daysTextField setTag:TEXTFIELD_DAYS_TAG];

        //[datas setObject:cell.startDateTextField forKey:POSTVIEWCONTROLLER_STARTDATE_KEY];
        //[datas setObject:cell.daysTextField forKey:POSTVIEWCONTROLLER_DAYS_KEY];
        return cell;
    } else if (indexPath.row == 2) {
        
        SharePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tapped.numberOfTapsRequired = 1;
        [cell.sharePhotoImageView addGestureRecognizer:tapped];
        cell.sharePhotoImageView.userInteractionEnabled = YES;
        
        return cell;
    }
    else {
        
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        return cell;
    }
    
    
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result;
    
    if(indexPath.row == 0 || indexPath.row == 1){
        result = 90.0;
        
        /*
        NSString * memo = _cellDictData[@"memo"];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:memo attributes:attributes];
        
        //寬度固定計算行高(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
        CGRect rect = [attrString boundingRectWithSize:CGSizeMake(296.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        //NSLog(@"rect:%@",NSStringFromCGRect(rect));
        //NSLog(@"rect height = %f",rect.size.height);
        result += rect.size.height;*/
        
    }else if(indexPath.row == 2) {
        result = 350.0;
    
    }else if(indexPath.row == 3) {
        result = 180.0;
    }
    else{
        result = 80.0;
    }
    
    return result;
}

#pragma mark - Gesture Method

//Method controlling what happens when cell's UIImage is tapped
-(void)imageTapped:(UIGestureRecognizer*)gesture
{
    
    selectedImageView=(UIImageView*)[gesture view];
    
    UIAlertController * alertController = [UIAlertController new];
    if(imagePicker==nil)
        imagePicker = [[UIImagePickerController alloc]init];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // NSLog(@"拍攝照片");
        // 先檢查裝置是否配備相機
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            
            // 設定相片來源為裝置上的相機
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 設定imagePicker的delegate為ViewController
            imagePicker.delegate = self;
            imagePicker.allowsEditing=true;
            //開起相機拍照界面
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"選擇照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        // 讀取照片
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.sourceType=sourceType;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
        imagePicker.allowsEditing=true; // 調整大小
        imagePicker.delegate=self;
        
        [self presentViewController:imagePicker animated:true completion:nil];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //NSLog(@"cancel");
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        //NSLog(@"didshow");
    }];
}

#pragma mark - TextField Delegate Method
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [datas setObject:textField.text forKey:[NSNumber numberWithInteger:textField.tag]];
}

#pragma mark - Camera Picker Method
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 顯示照片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = info[UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        //      UIImage *originaImage = info
        //      [UIImagePickerControllerOriginalImage];
        UIImage *editedImage = info
        [UIImagePickerControllerEditedImage];
        //_theImageView.image=editedImage;
        
        NSData *imageData = [PAPUtility resizeImage:editedImage width:500.0 height:500.0];
        NSLog(@"Size of Image(bytes):%ld",[imageData length]);
        [selectedImageView setImage:[UIImage imageWithData:imageData]];
    }
    [picker dismissViewControllerAnimated:true completion:nil];
    
    
    // 取得使用者拍攝的照片
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //[selectedImageView setImage:image];
//    // 存檔
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
