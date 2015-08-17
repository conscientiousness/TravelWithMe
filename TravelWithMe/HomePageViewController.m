//
//  ViewController.m
//  UITableView Parallax
//
//  Created by Hank on 2015/8/10.
//  Copyright (c) 2015年 Hank. All rights reserved.
//

#import "HomePageViewController.h"
#import "ParallaxTableViewCell.h"

@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * tableItems;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
//    self.tableItems = @[[UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"],
//                        [UIImage imageNamed:@"bg-blur-image.png"]];

    self.tableItems = @[[UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_4.jpg"],
                        [UIImage imageNamed:@"demo_5.jpg"],
                        [UIImage imageNamed:@"demo_6.jpg"],
                        [UIImage imageNamed:@"demo_7.jpg"],
                        [UIImage imageNamed:@"demo_8.jpg"],
                        [UIImage imageNamed:@"demo_9.jpg"],
                        [UIImage imageNamed:@"demo_10.jpg"],
                        [UIImage imageNamed:@"demo_11.jpg"],
                        [UIImage imageNamed:@"demo_12.jpg"],
                        [UIImage imageNamed:@"demo_13.jpg"],
                        [UIImage imageNamed:@"demo_14.jpg"]];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier =@"mycell";
    ParallaxTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.parallaxLabel.text=[NSString stringWithFormat:@"Fila %li",indexPath.row];
    cell.parallaxImage.image=[self.tableItems objectAtIndex:indexPath.row];
     return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (ParallaxTableViewCell*cell in visibleCells){
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    
    
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
