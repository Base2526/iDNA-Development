//
//  ChatWall.m
//  iDNA
//
//  Created by Somkid on 14/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ChatWall.h"

@interface ChatWall ()

@end

@implementation ChatWall
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setTitle:@"Home"];
    
    /*
     แสดงปุ่ม Back
     */
    // https://stackoverflow.com/questions/4964276/navigationitem-backbarbuttonitem-not-working-why-is-the-previous-menu-still-sho
    
    /*
     ใส่ icon ตรงปุ่ม Back
     UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"]
     style:UIBarButtonItemStylePlain
     target:self.navigationController
     action:@selector(popViewControllerAnimated:)];
     */
//    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissMyView)];

    // self.hidesBottomBarWhenPushed = YES;
    
    self.title = type;
}

/*
 -(BOOL)hidesBottomBarWhenPushed
 {
 return YES;
 }
 */

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissMyView {
    // [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
