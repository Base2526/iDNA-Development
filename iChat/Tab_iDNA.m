//
//  Tab_iDNA.m
//  iChat
//
//  Created by Somkid on 10/11/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "Tab_iDNA.h"
#import "Configs.h"

#import "Cell_H_TabiDNA.h"
#import "Cell_H_S_TabiDNA.h"
#import "Cell_Item_TabiDNA.h"
#import "Cell_Item_Following_TabiDNA.h"
#import "RecipeViewCell.h"
#import "AppDelegate.h"
#import "CreateMyApplication.h"
#import "MyApp.h"
#import "MyApplicationsRepo.h"
#import "MyApplications.h"
#import "YSLContainerViewController.h"
#import "Tab_iDNA_MyApp.h"
#import "Tab_iDNA_Center.h"
#import "Tab_iDNA_Following.h"

@interface Tab_iDNA ()
{
    YSLContainerViewController *containerVC;
}

@end

@implementation Tab_iDNA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Tab_iDNA_MyApp *tabMyApp = [storybrd instantiateViewControllerWithIdentifier:@"Tab_iDNA_MyApp"];
    tabMyApp.title = @"My App";
    
    Tab_iDNA_Center *tabCenter = [storybrd instantiateViewControllerWithIdentifier:@"Tab_iDNA_Center"];
    tabCenter.title = @"Center";
    
    Tab_iDNA_Following *tabFollower = [storybrd instantiateViewControllerWithIdentifier:@"Tab_iDNA_Following"];
    tabFollower.title = @"Following";
    
//    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[tabMyApp, tabCenter, tabFollower]
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    containerVC.delegate = self;
    // containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];

    [self.view addSubview:containerVC.view];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"Tab_iDNA"
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Tab_iDNA" object:nil];
}

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    NSMutableArray *items = [containerVC childControllers];
    
    NSObject *object = [items objectAtIndex:index];
    if ([object isKindOfClass:[Tab_iDNA_MyApp class]]) {
        [((Tab_iDNA_MyApp *)object) reloadData:nil];
    }else if([object isKindOfClass:[Tab_iDNA_Center class]]){
        [((Tab_iDNA_Center *)object) reloadData:nil];
        [((Tab_iDNA_Center *)object) reloadDataCenterSlide:nil];
    }else if([object isKindOfClass:[Tab_iDNA_Following class]]){
        [((Tab_iDNA_Following *)object) reloadData:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
