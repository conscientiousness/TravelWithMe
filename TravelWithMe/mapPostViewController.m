//
//  mapPostViewController.m
//  TravelWithMe
//
//  Created by ajay on 2015/8/10.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "mapPostViewController.h"
#import "VBFPopFlatButton.h"


@interface mapPostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *regionTagText;

@end

@implementation mapPostViewController
{
    UIImage *pickImage;
    PFUser *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    //
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //[self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //[self.tabBarController.tabBar setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    if (!user) {
        user = [PFUser currentUser];
    }
}

- (void)initUI {
    
    self.view.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.0];
    self.view.opaque = NO;

}

- (IBAction)backBtnPressed:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"backBtnPressed");
    }];
    
}

- (IBAction)saveBtnPressed:(id )sender {
    
    if(user) {
        
        MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"上傳中...";
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            PFObject *travelMatePost = [PFObject objectWithClassName:@"TravelMatePost"];
        
            travelMatePost[@"regionTag"] = _regionTagText.text;
            
            
            //照片 UIImage imageNamed:@"pic900X640.jpg"
            
            NSData *imageData;// = [PAPUtility resizeImage:pickImage];
            
            PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"testPhoto.jpg"] data:imageData];
            travelMatePost[@"photo"] = imageFile;
            
                      
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得使用者拍攝的照片
    pickImage = [info valueForKey:UIImagePickerControllerOriginalImage];
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
