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
#import "MemoTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SCLAlertView.h"

@interface PostViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    UIImage *pickImage;
    NSMutableDictionary *datas;
    UIImagePickerController *imagePicker;
    UIImageView *selectedImageView;
    UIDatePicker *datepicker;
    UIToolbar *toolBar;
    PFUser *user;
}
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@end

@implementation PostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!user) {
        user = [PFUser currentUser];
    }
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect tableViewNewFrame = _postTableView.frame;
    tableViewNewFrame.size.height += self.tabBarController.tabBar.frame.size.height;
    [_postTableView setFrame:tableViewNewFrame];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)initUI {

    UIBarButtonItem *nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"發佈" style:UIBarButtonItemStylePlain target:self action:@selector(publishBtnPressed:)];
    nextStepButton.enabled = YES;
    self.navigationItem.rightBarButtonItem = nextStepButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //關閉分隔線
    [_postTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)publishBtnPressed:(id *)sender {
    [self.view endEditing:YES];
    
    //NSLog(@"%@",datas);
    
    if([self isDataNotEmpty]){
        if(user) {
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"發送中...";
            
            dispatch_queue_t publishQueue = dispatch_queue_create("publish", nil);
            
            dispatch_async(publishQueue, ^{
                
                PFObject *travelMatePost = [PFObject objectWithClassName:TRAVELMATEPOST_TABLENAME];
                travelMatePost[TRAVELMATEPOST_COUNTRYCITY_KEY] = [datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_COUNTRYCITY_TAG]];
                travelMatePost[TRAVELMATEPOST_MEMO_KEY] = [datas objectForKey:[NSNumber numberWithInteger: TEXTVIEW_MEMO_TAG]];
                
                //出發日期
                //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",[datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_STARTDATE_TAG]]]];
                //NSLog(@"%@ => %@",[NSString stringWithFormat:@"%@ 00:00:00",[datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_STARTDATE_TAG]]],startDate);
                NSString *startDate = [datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_STARTDATE_TAG]];
                //NSLog(@"%@",startDate);
                travelMatePost[TRAVELMATEPOST_STARTDATE_KEY] = startDate;
                
                //顯示用方形照片
                PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"photo.jpg"] data:[datas objectForKey:[NSNumber numberWithInteger: IMAGEVIEW_SHAREPHOTO_TAG]]];
                //小方形照片
                PFFile *smallImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"smallPhoto.jpg"] data:[datas objectForKey:TRAVELMATEPOST_SMALLPHOTO_KEY]];
                //原始大小縮圖照片
                PFFile *originalImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"originalPhoto.jpg"] data:[datas objectForKey:TRAVELMATEPOST_ORIGINALPHOTO_KEY]];
                
                travelMatePost[TRAVELMATEPOST_PHOTO_KEY] = imageFile;
                travelMatePost[TRAVELMATEPOST_SMALLPHOTO_KEY] = smallImageFile;
                travelMatePost[TRAVELMATEPOST_ORIGINALPHOTO_KEY] = originalImageFile;
                
                
                //出發天數
                travelMatePost[TRAVELMATEPOST_DAYS_KEY] = [NSNumber numberWithInteger:[[datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_DAYS_TAG]] integerValue]];
                
                travelMatePost[COMMON_POINTER_CREATEUSER_KEY] = user;
                
                //計數
                travelMatePost[TRAVELMATEPOST_COMMENTCOUNT_KEY] = @0;
                travelMatePost[TRAVELMATEPOST_JOINCOUNT_KEY] = @0;
                travelMatePost[TRAVELMATEPOST_INTERESTEDCOUNT_KEY] = @0;
                travelMatePost[TRAVELMATEPOST_WATCHCOUNT_KEY] = @0;
                
                [travelMatePost save];
                
                PFRelation *relation = [user relationForKey:USER_RELATION_TRAVELMATEPOSTS_KEY];
                [relation addObject:travelMatePost];
                [user save];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isDataSave" object:self];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }
    } else {
        
    }
    
}

- (BOOL) isDataNotEmpty {
    
    BOOL result = YES;
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor customGreenColor];
    NSString *icon = @"exclamation-icon";
    NSString *title;
    NSString *subTitle;
    
    NSString *countryCityStr = [datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_COUNTRYCITY_TAG]];
    
    NSString *memoStr = [datas objectForKey:[NSNumber numberWithInteger: TEXTVIEW_MEMO_TAG]];
    
    NSString *startDateStr = [datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_STARTDATE_TAG]];
    
    NSString *daysStr = [datas objectForKey:[NSNumber numberWithInteger: TEXTFIELD_DAYS_TAG]];
    
    NSData *sharePhotoData = [datas objectForKey:[NSNumber numberWithInteger: IMAGEVIEW_SHAREPHOTO_TAG]];
    
    if (countryCityStr==nil || [countryCityStr isEqualToString:@""])
    {
        title = @"還沒填唷!";
        subTitle = @"前往國家,城市或地區";
        result = NO;
    }
    else if (startDateStr==nil || [startDateStr isEqualToString:@""])
    {
        title = @"還沒填唷!";
        subTitle = @"出發時間";
        result = NO;
    }
    else if (daysStr==nil || [daysStr isEqualToString:@""])
    {
        title = @"還沒填唷!";
        subTitle = @"旅遊天數";
        result = NO;
    }
    else if (memoStr==nil || [memoStr isEqualToString:@""])
    {
        title = @"還沒填唷!";
        subTitle = @"行程介紹";
        result = NO;
    }
    else if (sharePhotoData==nil)
    {
        title = @"沒照片唷!";
        subTitle = @"上傳一張自己喜愛的美景吧";
        result = NO;
    }
    
    if(!result)
        [alert showCustom:self image:[UIImage imageNamed:icon] color:color title:title subTitle:subTitle closeButtonTitle:@"OK" duration:0.0f];
    
    return result;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
        
    } else if (indexPath.row == 1) {
    
        StartDateDaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        [cell.startDateTextField setTag:TEXTFIELD_STARTDATE_TAG];
        [cell.daysTextField setTag:TEXTFIELD_DAYS_TAG];

        [self prepareDataPicker];
        [cell.startDateTextField setInputView:datepicker];
        [cell.startDateTextField setInputAccessoryView:toolBar];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    } else if (indexPath.row == 2) {
        
        SharePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        //給予imageView手勢行為：點一次觸發
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tapped.numberOfTapsRequired = 1;
        [cell.sharePhotoImageView addGestureRecognizer:tapped];
        cell.sharePhotoImageView.userInteractionEnabled = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (indexPath.row == 3) {
        
        MemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        [cell.memoTextField setTag:TEXTVIEW_MEMO_TAG];
        
        [cell.memoTextField.layer setBackgroundColor: [[UIColor clearColor] CGColor]];
        [cell.memoTextField.layer setBorderColor: [[UIColor colorWithRed:0.533 green:0.544 blue:0.562 alpha:1.000] CGColor]];
        [cell.memoTextField.layer setBorderWidth: 2.0];
        [cell.memoTextField.layer setCornerRadius:5.0f];
        [cell.memoTextField.layer setMasksToBounds:YES];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
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

#pragma mark - TextView Delegate Method
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if((textView.tag == TEXTVIEW_MEMO_TAG) && ([textView.text isEqual:@""]||textView.text==nil)) {
        [textView.layer setBorderColor: [[UIColor colorWithRed:0.533 green:0.544 blue:0.562 alpha:1.000] CGColor]];
    }
    
    
    [datas setObject:textView.text forKey:[NSNumber numberWithInteger:textView.tag]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if(textView.tag == TEXTVIEW_MEMO_TAG) {
         
         [textView.layer setBorderColor: [[UIColor colorWithRed:0.263 green:0.718 blue:0.608 alpha:1.000] CGColor]];
    }
    
    return true;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 選取完後取得照片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSString *type = info[UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        //原始大小
        UIImage *originaImage = info[UIImagePickerControllerOriginalImage];
        //原始大小圖縮圖和壓縮
        NSData *originaImageData = [PAPUtility resizeImage:originaImage width:1080.0 height:1080.0 contentMode:UIViewContentModeScaleAspectFill];
        
        //方形圖
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        //方形圖縮圖和壓縮
        NSData *imageData = [PAPUtility resizeImage:editedImage width:500.0 height:500.0 contentMode:UIViewContentModeScaleAspectFill];
        //方形圖縮小圖和壓縮
        NSData *smallImageData = [PAPUtility resizeImage:editedImage width:100.0 height:100.0 contentMode:UIViewContentModeScaleAspectFill];
        
        [datas setObject:imageData forKey:[NSNumber numberWithInteger:IMAGEVIEW_SHAREPHOTO_TAG]];
        [datas setObject:smallImageData forKey:TRAVELMATEPOST_SMALLPHOTO_KEY];
        [datas setObject:originaImageData forKey:TRAVELMATEPOST_ORIGINALPHOTO_KEY];
        

        [selectedImageView setImage:[UIImage imageWithData:imageData]];
    }
    [picker dismissViewControllerAnimated:true completion:nil];
    
    
    // 取得使用者拍攝的照片
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //[selectedImageView setImage:image];
//    // 存檔
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    // 關閉拍照程式
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - datePicker Method
- (void) prepareDataPicker
{
    
    if(datepicker==nil) {
        
        datepicker=[[UIDatePicker alloc]init];
        [datepicker setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
        datepicker.datePickerMode=UIDatePickerModeDate;
    }
    
    if(toolBar==nil){
        
        toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor colorWithRed: 1.0 green: 0.5781 blue: 0.0 alpha: 1.0]];
        [toolBar setTranslucent:YES];
        [toolBar setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    }
}

-(void)showSelectedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:datepicker.date];
    
    [datas setObject:strDate forKey:[NSNumber numberWithInteger:TEXTFIELD_STARTDATE_TAG]];
    
    UITextField *targetTextField = (UITextField*)[_postTableView viewWithTag:TEXTFIELD_STARTDATE_TAG];
    
    //NSLog(@"%@",[_postTableView viewWithTag:TEXTFIELD_STARTDATE_TAG]);
    
    targetTextField.text = strDate;
    [targetTextField resignFirstResponder];
}

@end
