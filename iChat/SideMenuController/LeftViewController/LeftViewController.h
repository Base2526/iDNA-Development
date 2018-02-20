//
//  LeftViewController.h
//  LGSideMenuControllerDemo
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

//@interface LeftViewController : UITableViewController

@interface LeftViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet HJManagedImageV *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@end
