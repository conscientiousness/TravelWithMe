//
//  EditProfileViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/10/4.
//  Copyright © 2015年 Jesse. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+CircleLayer.h"
#import "SCLAlertView.h"

#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 1

#define EDITPROFILE_TEXTFIELD_DISPLAYNAME_TAG 1000
#define EDITPROFILE_TEXTFIELD_EMAIL_TAG 2000
#define EDITPROFILE_TEXTFIELD_LINE_TAG 3000
#define EDITPROFILE_TEXTFIELD_WECHAT_TAG 4000
#define EDITPROFILE_TEXTFIELD_FACEBOOK_TAG 5000

#define GETDATA(KEY) [datas objectForKey:[NSNumber numberWithInteger: KEY]]

@interface EditProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage *pickImage;
    NSMutableDictionary *datas;
    UIImagePickerController *imagePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareUI {
    
    //是否為使用者本身
    if(_user==[PFUser currentUser]){
        //儲存按鈕
        UIImage *image = [UIImage imageNamed:@"save-icon.png"];
        CGRect frame = CGRectMake(0, 0, 32, 32);
        //init a normal UIButton using that image
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
        //設定觸發事件
        [button addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchDown];
        //finally, create UIBarButtonItem using that button
        UIBarButtonItem *postBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = postBarButtonItem;
        
        //給予imageView手勢行為：點一次觸發
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tapped.numberOfTapsRequired = 1;
        [_headPhoto addGestureRecognizer:tapped];
        _headPhoto.userInteractionEnabled = YES;
    }
    
    //圓形照片
    UIColor *genderColor;
    if([_user[USER_GENDER_KEY] isEqualToString:@"male"]) {
        genderColor = [UIColor boyPhotoBorderColor];
    } else if([_user[USER_GENDER_KEY] isEqualToString:@"female"]) {
        genderColor = [UIColor girlPhotoBorderColor];
    } else {
        genderColor = [UIColor customGreenColor];
    }
    [UIImageView circleImageView:_headPhoto borderWidth:3.0f borderColor:genderColor];
    PFFile *photo = (PFFile *)[_user objectForKey:USER_PROFILEPICTUREMEDIUM_KEY];
    [_headPhoto sd_setImageWithURL:(NSURL*)photo.url placeholderImage:[UIImage imageNamed:@"tmp-loading-image"]];
    
    //tableView背景色
    _tableview.backgroundColor = [UIColor clearColor];

}

- (void)saveBtnPressed:(id)sender {
    [self.view endEditing:YES];
    
    //NSLog(@"%@",datas);
    
    if([self isDataNotEmpty]){
        MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[CustomAnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 64,64)];
        hud.labelText = @"Sending...";
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        dispatch_queue_t publishQueue = dispatch_queue_create("profile_save", nil);
        
        dispatch_async(publishQueue, ^{
            
            //照片-小
            if(datas[USER_PROFILEPICTURESMALL_KEY]!=nil){
                PFFile *smallImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"smallPhoto.jpg"] data:[datas objectForKey:USER_PROFILEPICTURESMALL_KEY]];
                _user[USER_PROFILEPICTURESMALL_KEY] = smallImageFile;
            }
            
            //照片-中
            if(datas[USER_PROFILEPICTUREMEDIUM_KEY]!=nil){
                PFFile *originalImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"originalPhoto.jpg"] data:[datas objectForKey:TRAVELMATEPOST_ORIGINALPHOTO_KEY]];
                _user[TRAVELMATEPOST_ORIGINALPHOTO_KEY] = originalImageFile;
            }
            
            //NAME
            if(GETDATA(EDITPROFILE_TEXTFIELD_DISPLAYNAME_TAG)!=nil){
                _user[USER_DISPLAYNAME_KEY] = GETDATA(EDITPROFILE_TEXTFIELD_DISPLAYNAME_TAG);
            }
            
            //EMAIL
            if(GETDATA(EDITPROFILE_TEXTFIELD_EMAIL_TAG)!=nil){
                _user[USER_EMAIL_KEY] = GETDATA(EDITPROFILE_TEXTFIELD_EMAIL_TAG);
            }
            //LINE
            if(GETDATA(EDITPROFILE_TEXTFIELD_LINE_TAG)!=nil){
                _user[USER_LINE_KEY] = GETDATA(EDITPROFILE_TEXTFIELD_LINE_TAG);
            }
            //WECHAT
            if(GETDATA(EDITPROFILE_TEXTFIELD_WECHAT_TAG)!=nil){
                _user[USER_WECHAT_KEY] = GETDATA(EDITPROFILE_TEXTFIELD_WECHAT_TAG);
            }
            //FACEBOOK
            if(GETDATA(EDITPROFILE_TEXTFIELD_FACEBOOK_TAG)!=nil){
                _user[USER_FACEBOOK_KEY] = GETDATA(EDITPROFILE_TEXTFIELD_FACEBOOK_TAG);
            }
            
            [_user save];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                 self.navigationItem.rightBarButtonItem.enabled = YES;
            });
        });
    }
}

- (BOOL) isDataNotEmpty {
    
    BOOL result = YES;
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor customGreenColor];
    NSString *icon = @"exclamation-icon";
    NSString *title;
    NSString *subTitle;
    
    NSString *name = GETDATA(EDITPROFILE_TEXTFIELD_DISPLAYNAME_TAG);
    
    if (name==nil || [name isEqualToString:@""])
    {
        title = @"名稱還沒填唷!";
        subTitle = @"這樣不知道怎麼稱呼您呢!";
        result = NO;
    }
    
    if(!result)
        [alert showCustom:self image:[UIImage imageNamed:icon] color:color title:title subTitle:subTitle closeButtonTitle:@"OK" duration:0.0f];
    
    return result;
}

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
    }
    
    if (indexPath.row == 0) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell.displayNme setTag:EDITPROFILE_TEXTFIELD_DISPLAYNAME_TAG];
        cell.displayNme.text = _user[USER_DISPLAYNAME_KEY];
        
        [cell.email setTag:EDITPROFILE_TEXTFIELD_EMAIL_TAG];
        cell.email.text = _user[USER_EMAIL_KEY];
        
        [cell.line setTag:EDITPROFILE_TEXTFIELD_LINE_TAG];
        cell.line.text = _user[USER_LINE_KEY];
        
        [cell.wechat setTag:EDITPROFILE_TEXTFIELD_WECHAT_TAG];
        cell.wechat.text = _user[USER_WECHAT_KEY];
        
        [cell.facebook setTag:EDITPROFILE_TEXTFIELD_FACEBOOK_TAG];
        cell.facebook.text = _user[USER_FACEBOOK_KEY];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }

    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat result;
    
    result = 400.0;
        
        /*
         NSString * memo = _cellDictData[@"memo"];
         NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12]};
         NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:memo attributes:attributes];
         
         //寬度固定計算行高(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
         CGRect rect = [attrString boundingRectWithSize:CGSizeMake(296.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
         //NSLog(@"rect:%@",NSStringFromCGRect(rect));
         //NSLog(@"rect height = %f",rect.size.height);
         result += rect.size.height;*/
        
    
    return result;
}

#pragma mark - Gesture Method

//Method controlling what happens when cell's UIImage is tapped
-(void)imageTapped:(UIGestureRecognizer*)gesture
{
    
    
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_user != [PFUser currentUser]) return NO;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - TextView Delegate Method
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [datas setObject:textView.text forKey:[NSNumber numberWithInteger:textView.tag]];
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
        //方形圖
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        //方形圖縮圖和壓縮
        NSData *imageData = [PAPUtility resizeImage:editedImage width:280.0 height:280.0 contentMode:UIViewContentModeScaleAspectFill];
        //方形圖縮小圖和壓縮
        NSData *smallImageData = [PAPUtility resizeImage:editedImage width:70.0 height:70.0 contentMode:UIViewContentModeScaleAspectFill];
        
        [datas setObject:smallImageData forKey:USER_PROFILEPICTURESMALL_KEY];
        [datas setObject:imageData forKey:USER_PROFILEPICTUREMEDIUM_KEY];
        
        [_headPhoto setImage:[UIImage imageWithData:imageData]];
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

@end


