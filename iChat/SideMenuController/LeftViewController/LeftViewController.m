//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "MyProfile.h"
#import "Configs.h"
#import "AppDelegate.h"
#import "ProfilesRepo.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController
@synthesize tableView, imageV, labelName, viewTop;

- (void)viewDidLoad {
    [super viewDidLoad];

    // -----

//    self.titlesArray = @[@"Open Right View",
//                         @"",
//                         @"Change Root VC",
//                         @"",
//                         @"Profile",
//                         @"News",
//                         @"Articles",
//                         @"Video",
//                         @"Music"];
    
    self.titlesArray = @[@"My Profile"];

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [viewTop addGestureRecognizer:singleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // NSMutableDictionary *data = [[Configs sharedInstance] loadData:_DATA];
    // NSMutableDictionary *profiles = [data objectForKey:@"profiles"];
    
    ProfilesRepo *profilesRepo = [[ProfilesRepo alloc] init];
    NSArray *pf = [profilesRepo get];
    if (pf == nil) {
        return;
    }
    
    NSDictionary* profiles = [NSJSONSerialization JSONObjectWithData:[[pf objectAtIndex:[profilesRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // [all_data setValue:profiles  forKey:@"profiles"];
    
    if ([profiles objectForKey:@"image_url"]) {
        [imageV clear];
        [imageV showLoadingWheel];
        [imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV];
    }else{}
    
    labelName.text = [NSString stringWithFormat:@"%@", [profiles objectForKey:@"name"]];//;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
//    if ([profiles objectForKey:@"image_url"]) {
//        [cell.imageV clear];
//        [cell.imageV showLoadingWheel];
//        [cell.imageV setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Configs sharedInstance].API_URL,[profiles objectForKey:@"image_url"]]]];
//        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:cell.imageV];
//    }else{}

    // cell.titleLabel.text = [NSString stringWithFormat:@"%@", [profiles objectForKey:@"name"]];//;
    cell.separatorView.hidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0;
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;

    [mainViewController hideLeftViewAnimated:YES completionHandler:^(void) {
        if (indexPath.section == 0) {
        }
    }];
    /*
    if (indexPath.row == 0) {
        if (mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation) {
            [mainViewController showRightViewAnimated:YES completionHandler:nil];
        }
        else {
            [mainViewController hideLeftViewAnimated:YES completionHandler:^(void) {
                [mainViewController showRightViewAnimated:YES completionHandler:nil];
            }];
        }
    }
    else if (indexPath.row == 2) {
        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        UIViewController *viewController;

        if ([navigationController.viewControllers.firstObject isKindOfClass:[ViewController class]]) {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherViewController"];
        }
        else {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        }

        [navigationController setViewControllers:@[viewController]];

        // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
        // You can use delay to avoid this and probably other unexpected visual bugs
        [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    }
    else {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = self.titlesArray[indexPath.row];

        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        [navigationController pushViewController:viewController animated:YES];

        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    */
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MyProfile* tabHome = [storybrd instantiateViewControllerWithIdentifier:@"MyProfile"];
        tabHome.isMenu = @"1";
        
        UINavigationController* navTabHome = [[UINavigationController alloc] initWithRootViewController:tabHome];
        navTabHome.navigationBar.topItem.title = @"My Profile";
        [self presentViewController:navTabHome animated:YES completion:^{
            MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }];
    });
}
@end
