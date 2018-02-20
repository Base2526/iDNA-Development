//
//  AddByIDViewController.m
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "AddByIDViewController.h"
#import "SVProgressHUD.h"
#import "ResultSearchFriend.h"
#import "AppConstant.h"
#import "FindFriendThread.h"
#import "Configs.h"
#import "ProfilesRepo.h"
#import "AppDelegate.h"

@interface AddByIDViewController (){
    NSDictionary *jsonDict;
}
@end

@implementation AddByIDViewController
@synthesize btnAdd;
@synthesize imageV_friend, textView_message, btnAddFriend;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnAdd.layer.cornerRadius = 5;
    btnAdd.layer.borderWidth = 1;
    btnAdd.layer.borderColor = [UIColor blueColor].CGColor;
        
    imageV_friend.hidden    = YES;
    textView_message.hidden = YES;
    btnAddFriend.hidden     = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.textfID resignFirstResponder];
}

- (IBAction)onFind:(id)sender {
    imageV_friend.hidden    = YES;
    textView_message.hidden = YES;
    btnAddFriend.hidden     = YES;
    
    [imageV_friend clear];
    
    NSString *code = [self.textfID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([code length] < 1) {
        [SVProgressHUD showErrorWithStatus:@"ID Empty."];
    }else{
        
        [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
        FindFriendThread *ff = [[FindFriendThread alloc] init];
        [ff setCompletionHandler:^(NSData *data) {
            
            jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            [[Configs sharedInstance] SVProgressHUD_Dismiss];
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageV_friend.hidden = NO;
                    textView_message.hidden = NO;
                
                    if ([jsonDict[@"friend_status"] isEqualToString:@"0"]) {
                        // แสดงยังไม่ได้ เป้นเพือนสามารถเพิ่มเพือนได้
                        btnAddFriend.hidden     = NO;
                        
                        if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"10"]) {
                        // Friend กรณีเราเป็นเพือนกันอยู่แล้ว
                        
                        if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                        
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"13"]) {
                        // Friend Cancel : กรณีเราเคยขอเป้นเพือนแล้วโดน เพือน กด cancel
                        
                        if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"11"]) {
                        // Friend request : กรณีเราส่งคำขอเป้นเพือน
                        if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"12"]) {
                        // Wait for a friend : เพือนคนนี้ส่งคำขอ ขอเราเป็นเพือน
                        if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"-1"]) {
                        // Friend not found : ไม่มีคนทีตั้ง code นี้
                    }else  if ([jsonDict[@"friend_status"] isEqualToString:@"99"]) {
                        // You can't add yourself as a friend. : ตัวเอง(My self)
                        
                        ProfilesRepo *profileRepo = [[ProfilesRepo alloc] init];
        
                        NSArray *pf = [profileRepo get];
                        NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if ([profiles objectForKey:@"image_url"]) {
                            [imageV_friend clear];
                            [imageV_friend showLoadingWheel]; // API_URL
                            [imageV_friend setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [profiles objectForKey:@"image_url"]]]];
                            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:imageV_friend ];
                        }else{
                            [imageV_friend setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                        }
                    }
                    [textView_message setText:jsonDict[@"message"]];
                });
            }else{
                NSLog(@"");
            }
        }];
        
        [ff setErrorHandler:^(NSString *error) {
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
        }];
        [ff start:@"0" :code];
    }
}

- (IBAction)onAddFriend:(id)sender {
    [SVProgressHUD showWithStatus:@"Wait."];
    
    NSString* friend_id =[jsonDict objectForKey:@"friend_id"];
    
    AddFriendThread *addFriendsThread = [[AddFriendThread alloc] init];
    [addFriendsThread setCompletionHandler:^(NSData *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            if ([jsonDict[@"friend_status"] isEqualToString:@"-1"]) {
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }else if ([jsonDict[@"friend_status"] isEqualToString:@"99"]) {

                // เพิ่มเพือนลง database
                NSDictionary *values = jsonDict[@"values"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateFriend:friend_id :jsonDict[@"values"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[Configs sharedInstance] SVProgressHUD_ShowSuccessWithStatus:jsonDict[@"message"]];
                });
            }
        }else{
            [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
        }
    }];
    
    [addFriendsThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
    }];
    [addFriendsThread start:friend_id];
}

-(void)AddByID:(NSNotification *)notice{
        
    NSDictionary *userInfo = notice.userInfo;
    
    NSString *uid_friend = @"";
    if ([userInfo objectForKey:@"uid_friend"]) {
        uid_friend = [userInfo objectForKey:@"uid_friend"];
    }
    
    NSDictionary *value =  @{@"uid_friend" : uid_friend };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:value];
    
    [self.navigationController popViewControllerAnimated:YES];
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
