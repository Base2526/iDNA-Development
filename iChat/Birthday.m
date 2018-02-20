//
//  Birthday.m
//  iDNA
//
//  Created by Somkid on 5/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import "Birthday.h"
#import "AppDelegate.h"
@interface Birthday (){
    FIRDatabaseReference *ref;
    NSMutableDictionary *profiles;
}

@end

@implementation Birthday
@synthesize datePicker, labelText;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ref = [[FIRDatabase database] reference];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:RELOAD_DATA_PROFILES
                                               object:nil];
    [self reloadData:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_DATA_PROFILES object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        profiles = [[Configs sharedInstance] getUserProfiles];
        if ([profiles objectForKey:@"birthday"]) {
            // selectedIndex = [profiles objectForKey:@"birthday"];
            
            NSTimeInterval timestamp = [[profiles objectForKey:@"birthday"] doubleValue];
            NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
            
            labelText.text = [[self getDateFormatter]  stringFromDate:lastUpdate];
            
            // NSDate *date=[formatter dateFromString:@"12:30 AM"];
            [datePicker setDate:lastUpdate];
        }else{
            NSTimeInterval timestamp = [datePicker.date timeIntervalSince1970];
            NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
            
            labelText.text = [[self getDateFormatter]  stringFromDate:lastUpdate];
        }
    });
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker{
    /*
     เราทำเป็น timestamp เพราะว่าต้องการ save บน server เป็น timestamp
     */
    NSTimeInterval timestamp = [datePicker.date timeIntervalSince1970];
    NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
    
    labelText.text = [[self getDateFormatter] stringFromDate:lastUpdate];
    
    NSMutableDictionary *newProfiles = [[NSMutableDictionary alloc] init];
    [newProfiles addEntriesFromDictionary:profiles];
    
    if ([newProfiles objectForKey:@"birthday"]) {
        [newProfiles removeObjectForKey:@"birthday"];
    }
    
    [newProfiles setValue:[NSString stringWithFormat:@"%f", timestamp] forKey:@"birthday"];
    
    
    
    NSString *child = [NSString stringWithFormat:@"%@%@/profiles/", [[Configs sharedInstance] FIREBASE_DEFAULT_PATH], [[Configs sharedInstance] getUIDU]];
    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"%@/", child]: newProfiles};
    
    [ref updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil) {
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateProfile:newProfiles];
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:@"Error update birthday."];
        }
    }];
}

-(NSDateFormatter *)getDateFormatter{
    NSDateFormatter __autoreleasing *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormat;
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
