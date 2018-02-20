// MXParallaxViewController.m
//
// Copyright (c) 2017 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MXContacts.h"
#import "MXSegmentedPager.h"
#import "Tab_Contacts.h"
#import "MXFreindsCell.h"
#import "MXGroupsCell.h"
#import "MXClasssCell.h"
#import "AddFriend.h"

@interface MXContacts () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
@property (nonatomic, strong) UIView            * cover;
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UITableView       * tbFriends;
@property (nonatomic, strong) UITableView       * tbGroups;
@property (nonatomic, strong) UITableView       * tbClasss;
@property (nonatomic, strong) UIWebView         * webView;
@property (nonatomic, strong) UITextView        * textView;
@end

@implementation MXContacts
@synthesize tbFriends, tbGroups, tbClasss;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.segmentedPager];
    
    // Parallax Header
    self.segmentedPager.parallaxHeader.view = self.cover;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 180;
    self.segmentedPager.parallaxHeader.minimumHeight = [self statusBarHeight] + self.navigationController.navigationBar.frame.size.height;
    
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

- (UITableView *)tabFriends {
    if (!tbFriends) {
        //Add a table page
        tbFriends = [[UITableView alloc] init];
        tbFriends.delegate = self;
        tbFriends.dataSource = self;
        tbFriends.tag = 0;
        
        
        [tbFriends registerNib:[UINib nibWithNibName:@"MXFreindsCell" bundle:nil] forCellReuseIdentifier:@"MXFreindsCell"];
    }
    return tbFriends;
}

- (UITableView *)tabGroups {
//    if (!_webView) {
//        // Add a web page
//        _webView = [[UIWebView alloc] init];
//        _webView.delegate = self;
//        NSString *strURL = @"http://nshipster.com/";
//        NSURL *url = [NSURL URLWithString:strURL];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        [_webView loadRequest:urlRequest];
//    }
//    return _webView;
    
    if (!tbGroups) {
        //Add a table page
        tbGroups = [[UITableView alloc] init];
        tbGroups.delegate = self;
        tbGroups.dataSource = self;
        tbGroups.tag = 1;
        
        [tbGroups registerNib:[UINib nibWithNibName:@"MXGroupsCell" bundle:nil] forCellReuseIdentifier:@"MXGroupsCell"];
    }
    return tbGroups;
}

- (UITextView *)tabClasss {
//    if (!_textView) {
//        // Add a text page
//        _textView = [[UITextView alloc] init];
//        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
//        _textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    }
//    return _textView;
    if (!tbClasss) {
        //Add a table page
        tbClasss = [[UITableView alloc] init];
        tbClasss.delegate = self;
        tbClasss.dataSource = self;
        tbClasss.tag = 2;
        
        [tbClasss registerNib:[UINib nibWithNibName:@"MXClasssCell" bundle:nil] forCellReuseIdentifier:@"MXClasssCell"];
    }
    return tbClasss;
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
    return @[@"Friends", @"Groups", @"Classs"][index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    return @[[self tabFriends], [self tabGroups], [self tabClasss]][index];
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = (indexPath.row % 2) + 1;
    [self.segmentedPager.pager showPageAtIndex:index animated:YES];
}

#pragma mark <UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 0:
            return 80;
            
        default:
            break;
    }
    return 80;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    switch (tableView.tag) {
        case 0:{
            text = @"0";
            
            MXFreindsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MXFreindsCell"];
            if (!cell){
                cell = [tableView dequeueReusableCellWithIdentifier:@"MXFreindsCell"];
            }
            
            return cell;
        }
            break;
            
        case 1:{
            text = @"1";
            
            MXGroupsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MXGroupsCell"];
            if (!cell){
                cell = [tableView dequeueReusableCellWithIdentifier:@"MXGroupsCell"];
            }
            
            return cell;
        }
            break;
            
        case 2:{
            text = @"2";
            
            MXClasssCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MXClasssCell"];
            if (!cell){
                cell = [tableView dequeueReusableCellWithIdentifier:@"MXClasssCell"];
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = text;//(indexPath.row % 2)? @"Text" : @"Web";
    
    return cell;
}

#pragma mark <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (IBAction)onAddFriend:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddFriend* addFriend = [storybrd instantiateViewControllerWithIdentifier:@"AddFriend"];
    // UINavigationController* navTabHome = [[UINavigationController alloc] initWithRootViewController:tabHome];
//    navTabHome.navigationBar.topItem.title = @"My Profile";
//    [self presentViewController:navTabHome animated:YES completion:nil];
    
    [self.navigationController pushViewController:addFriend animated:YES];
}
@end
