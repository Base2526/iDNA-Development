//
//  MXiDNA.m
//  iDNA
//
//  Created by Somkid on 17/12/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "MXiDNA.h"
#import "MXSegmentedPager.h"
#import "Tab_Contacts.h"
#import "MXFreindsCell.h"
#import "MXGroupsCell.h"
#import "MXClasssCell.h"

#import "TabStoreCell.h"

@interface MXiDNA () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView            * cover;
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UICollectionView  * cvMyapp;
@property (nonatomic, strong) UICollectionView  * cvCenters;
@property (nonatomic, strong) UICollectionView  * cvFollowing;
@end

@implementation MXiDNA
@synthesize cvMyapp, cvCenters, cvFollowing;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.segmentedPager];
    
    // Parallax Header
//    self.segmentedPager.parallaxHeader.view = self.cover;
//    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    // self.segmentedPager.parallaxHeader.height = 180;
    self.segmentedPager.parallaxHeader.height = self.segmentedPager.parallaxHeader.minimumHeight = [self statusBarHeight] + self.navigationController.navigationBar.frame.size.height;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 1.0f;
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    //    [self.segmentedPager.segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
    //        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor greenColor]}];
    //        return attString;
    //    }];
    
    /*
     กำหนดขนาดตัวอักษร
     */
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentedPager.segmentedControl setTitleTextAttributes:attributes];
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillLayoutSubviews {
    self.segmentedPager.frame = (CGRect){
        .origin = CGPointZero,
        .size   = self.view.frame.size
    };
    [super viewWillLayoutSubviews];
}

#pragma mark Properties

-(float) statusBarHeight
{
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (UIView *)cover {
    if (!_cover) {
        // Set a cover on the top of the view
        _cover = [self.nibBundle loadNibNamed:@"Cover" owner:nil options:nil].firstObject;
    }
    return _cover;
}

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager below the cover
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

- (UICollectionView *)cvMyApp {
    if (!cvMyapp) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        cvMyapp=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [cvMyapp setDataSource:self];
        [cvMyapp setDelegate:self];
        
        cvMyapp.tag = 0;
        
        // [cvMyapp registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [self.cvMyapp registerNib:[UINib nibWithNibName:@"TabStoreCell" bundle:nil] forCellWithReuseIdentifier:@"TabStoreCell"];

        [cvMyapp setBackgroundColor:[UIColor whiteColor]];
        //[cvMyapp setScrollIndicatorInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    
    return cvMyapp;
}

- (UICollectionView *)cvCenters {
    if (!cvCenters) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        cvCenters=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [cvCenters setDataSource:self];
        [cvCenters setDelegate:self];
        cvCenters.tag = 1;
        
        // [cvMyapp registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [cvCenters registerNib:[UINib nibWithNibName:@"TabStoreCell" bundle:nil] forCellWithReuseIdentifier:@"TabStoreCell"];
        
        [cvCenters setBackgroundColor:[UIColor whiteColor]];
        //[cvMyapp setScrollIndicatorInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    
    return cvCenters;
}

- (UITextView *)cvFollowing {
    //    if (!_textView) {
    //        // Add a text page
    //        _textView = [[UITextView alloc] init];
    //        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    //        _textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    }
    //    return _textView;
    if (!cvFollowing) {
        //Add a table page
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        cvFollowing=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [cvFollowing setDataSource:self];
        [cvFollowing setDelegate:self];
        cvFollowing.tag = 2;
        
        // [cvMyapp registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [cvFollowing registerNib:[UINib nibWithNibName:@"TabStoreCell" bundle:nil] forCellWithReuseIdentifier:@"TabStoreCell"];
        
        [cvFollowing setBackgroundColor:[UIColor whiteColor]];
    }
    return cvFollowing;
}

#pragma mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 25.0f;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didScrollWithParallaxHeader:(MXParallaxHeader *)parallaxHeader {
    NSLog(@"progress %f", parallaxHeader.progress);
}

#pragma mark <MXSegmentedPagerDataSource>
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 3;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"My Application", @"Centers", @"Following"][index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    return @[[self cvMyApp], [self cvCenters], [self cvFollowing]][index];
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = (indexPath.row % 2) + 1;
    [self.segmentedPager.pager showPageAtIndex:index animated:YES];
}

#pragma mark <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
#pragma mark <UIWebViewDelegate>


#pragma mark <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
//
//    cell.backgroundColor=[UIColor greenColor];
    
    TabStoreCell* cell = (TabStoreCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TabStoreCell" forIndexPath:indexPath];
    
    switch (collectionView.tag) {
        case 0:
        {
            cell.labelName.text = @"My App";
        }
            break;
        case 1:
        {
            cell.labelName.text = @"Center";
        }
            break;
        case 2:
        {
            cell.labelName.text = @"Following";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 100);
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);  // top, left, bottom, right
}
#pragma mark <UICollectionViewDelegate>

@end


