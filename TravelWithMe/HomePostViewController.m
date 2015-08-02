//
//  HomePostViewController.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/9.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "HomePostViewController.h"

@interface HomePostViewController ()
{
    //PFQuery *query;
}
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *fooLabel;
@property (weak, nonatomic) IBOutlet UILabel *updDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *idTextFueld;
@property (weak, nonatomic) IBOutlet UITextField *fooTextField;
@end

@implementation HomePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    //query = [PFQuery queryWithClassName:@"TestObject"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)initUI {
    
    //Add Save Button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)saveBtnPressed:(id *)sender {
    
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


#pragma mark - CUAD
- (IBAction)addBtnPressed:(id)sender {
}

- (IBAction)qryBtnPressed:(id)sender {
    
    //NSMutableArray *ary = []
    
    /*[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
}

- (IBAction)deleteBtnPressed:(id)sender {
}

- (IBAction)editBtnPressed:(id)sender {
}


@end
