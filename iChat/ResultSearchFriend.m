//
//  ResultSearchFriend.m
//  Heart
//
//  Created by Somkid on 12/21/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "ResultSearchFriend.h"
#import "ResultSearchFriendThread.h"
#import "SVProgressHUD.h"

#import "Configs.h"

#import "AppDelegate.h"
#import "AppConstant.h"

#import "FindFriendThread.h"
#import "ProfilesRepo.h"

@interface ResultSearchFriend (){
    // NSDictionary *result;
    NSDictionary *jsonDict;
}
@end

@implementation ResultSearchFriend
@synthesize queryStringDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSLog(@"%@", self.key_search);
    
    self.btnAdd.layer.cornerRadius = 5;
    self.btnAdd.layer.borderWidth = 1;
    self.btnAdd.layer.borderColor = [UIColor blueColor].CGColor;
    
    
    [self.btnAdd setHidden:YES];
    
    // result = [[NSDictionary alloc] init];
    
    // [SVProgressHUD showWithStatus:@"Please Wait"];
    
//    FindFriendThread
    /*
    ResultSearchFriendThread *RSFThread = [[ResultSearchFriendThread alloc] init];
    [RSFThread setCompletionHandler:^(NSString * data) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([self.isQR isEqualToString:@"0"]) {
            NSLog(@"");
            
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
                result = jsonDict[@"data"];
                
                NSLog(@"%@", result);
                
                NSLog(@"%@", [result objectForKey:@"field_profile_name"][@"und"][0][@"value"]);
                
                self.labelName.text =[result objectForKey:@"field_profile_name"][@"und"][0][@"value"];
                
                NSArray*profile2_img = [result objectForKey:@"field_profile_image"]; //[_dict objectForKey:@"profile2"][@"field_profile_image"];
                
                
                if ([profile2_img count] > 0) {
                    NSLog(@"%@", [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]);
                    
                    NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]];
                    
                    // if (![self.profile_picture isEqualToString:@""]) {
                    [self.hjmImg clear];
                    [self.hjmImg showLoadingWheel];
                    [self.hjmImg setUrl:[NSURL URLWithString:url]];
                    // [img setImage:[UIImage imageWithData:fileData]];
                    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    // }
                }
                
                NSString *status;
                
                if([jsonDict[@"status"] isKindOfClass:[NSNumber class]])
                {
                    //do stuff for NSNumber
                    status = [NSString stringWithFormat:@"%i", jsonDict[@"status"]];
                }else{
                    status = jsonDict[@"status"];
                }
                
                if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"] || [status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"4"]) {
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    [self.btnAdd setHidden:YES];
                }else{
                    [self.labelMessage setHidden:YES];
                    [self.btnAdd setTitle:@"Add Friend" forState:UIControlStateNormal];
                }

            }else{
                self.labelMessage.text = @"User not found";
                
                [self.btnAdd setHidden:YES];
                [self.labelName setHidden:YES];
            }
            
        }else{
            if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                
                result = jsonDict[@"data"];
                
                NSLog(@"%@", result);
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"");
                    
                    NSLog(@"%@", [result objectForKey:@"field_profile_name"][@"und"][0][@"value"]);
                    
                    self.labelName.text =[result objectForKey:@"field_profile_name"][@"und"][0][@"value"];
                    
                    
                    NSArray*profile2_img = [result objectForKey:@"field_profile_image"]; //[_dict objectForKey:@"profile2"][@"field_profile_image"];
                    
                    
                    if ([profile2_img count] > 0) {
                        NSLog(@"%@", [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]);
                        
                        NSString *url = [NSString stringWithFormat:@"%@/sites/default/files/%@", [Configs sharedInstance].API_URL, [result objectForKey:@"field_profile_image"][@"und"][0][@"filename"]];
                        
                        // if (![self.profile_picture isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel];
                        [self.hjmImg setUrl:[NSURL URLWithString:url]];
                        // [img setImage:[UIImage imageWithData:fileData]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                        // }
                    }
                    
                    NSString *status;
                    
                    if([jsonDict[@"status"] isKindOfClass:[NSNumber class]])
                    {
                        //do stuff for NSNumber
                        status = [NSString stringWithFormat:@"%i", jsonDict[@"status"]];
                    }else{
                        status = jsonDict[@"status"];
                    }
                    
                    if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"] || [status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"4"]) {
                        self.labelMessage.text = jsonDict[@"message"];
                        
                        [self.btnAdd setHidden:YES];
                    }else{
                        [self.labelMessage setHidden:YES];
                        [self.btnAdd setTitle:@"Add Friend" forState:UIControlStateNormal];
                    }
                }else{
                    self.labelMessage.text = @"User not found";
                    
                    [self.btnAdd setHidden:YES];
                    [self.labelName setHidden:YES];
                }
                // }
                
            }else{
                [SVProgressHUD showErrorWithStatus:jsonDict[@"output"]];
            }
        }
        
        
    }];

    [RSFThread setErrorHandler:^(NSString * data) {
        NSLog(@"%@", data);
        
        [SVProgressHUD dismiss];
    
        [SVProgressHUD  showErrorWithStatus:data];
    }];

    [RSFThread start:self.key_search: self.isQR];
    */
    
    
    [[Configs sharedInstance] SVProgressHUD_ShowWithStatus:@"Wait."];
    FindFriendThread *ff = [[FindFriendThread alloc] init];
    [ff setCompletionHandler:^(NSData *data) {
        
        jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // imageV_friend.hidden = NO;
                // textView_message.hidden = NO;
                
                
                
                if ([jsonDict[@"friend_status"] isEqualToString:@"0"]) {
                    // แสดงยังไม่ได้ เป้นเพือนสามารถเพิ่มเพือนได้
                    // btnAddFriend.hidden     = NO;
                    
                    [self.btnAdd setHidden:NO];
                    
                    if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"10"]) {
                    // Friend กรณีเราเป็นเพือนกันอยู่แล้ว
                    
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                    
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"13"]) {
                    // Friend Cancel : กรณีเราเคยขอเป้นเพือนแล้วโดน เพือน กด cancel
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"11"]) {
                    // Friend request : กรณีเราส่งคำขอเป้นเพือน
                    
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"12"]) {
                    // Wait for a friend : เพือนคนนี้ส่งคำขอ ขอเราเป็นเพือน
                    
                    self.labelMessage.text = jsonDict[@"message"];
                    if (![jsonDict[@"url_image"] isEqualToString:@""]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, jsonDict[@"url_image"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"-1"]) {
                    // Friend not found : ไม่มีคนทีตั้ง code นี้
                }else  if ([jsonDict[@"friend_status"] isEqualToString:@"99"]) {
                    // You can't add yourself as a friend. : ตัวเอง(My self)
                    
                    self.labelMessage.text = jsonDict[@"message"];
                    
                    ProfilesRepo *profileRepo = [[ProfilesRepo alloc] init];
                    
                    NSArray *pf = [profileRepo get];
                    NSData *data =  [[pf objectAtIndex:[profileRepo.dbManager.arrColumnNames indexOfObject:@"data"]] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSMutableDictionary *profiles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if ([profiles objectForKey:@"image_url"]) {
                        [self.hjmImg clear];
                        [self.hjmImg showLoadingWheel]; // API_URL
                        [self.hjmImg setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [Configs sharedInstance].API_URL, [profiles objectForKey:@"image_url"]]]];
                        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImg ];
                    }else{
                        [self.hjmImg setImage:[UIImage imageNamed:@"icon_peoples.png"]];
                    }
                }
                // if(!)
                if ([jsonDict objectForKey:@"name"] && ![[jsonDict objectForKey:@"name"] isEqual:[NSNull null]]) {
                    
                    [self.labelName setText:[jsonDict objectForKey:@"name"]];
                }
                
            });
            
        }else{
            NSLog(@"");
        }
    
    }];
    
    [ff setErrorHandler:^(NSString *error) {
        [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:error];
    }];
    [ff start:@"1" :[queryStringDictionary objectForKey:@"bii"]];
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

- (IBAction)onAddFriend:(id)sender {
    
    NSLog(@"");
   /*
    __block NSString* uid_friend = [result objectForKey:@"uid"];
    [SVProgressHUD showWithStatus:@"Add Friend"];
    
    AddFriendThread *addFriendsThread = [[AddFriendThread alloc] init];
    [addFriendsThread setCompletionHandler:^(NSData *data) {
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        [SVProgressHUD dismiss];
        
        NSMutableDictionary *dict = [[Configs sharedInstance] loadData:_USER_CONTACTS];
        
        BOOL flag = TRUE;
        NSString*key =@"Wait to Accept";
        
        NSMutableArray *_items = [[dict objectForKey:key] mutableCopy];
        if (_items == nil) {
            _items = [[NSMutableArray alloc] init];
        }
        if ([_items count] > 0) {
            for (int i = 0; i < [_items count]; i++) {
                if ([[[_items objectAtIndex:i] objectForKey:@"uid"] isEqualToString:[jsonDict[@"data_friend"] objectForKey:@"uid"]]) {
                    flag = FALSE;
                    
                    break;
                }
            }
        }
        
        if (flag) {
            
            
            [_items addObject:jsonDict[@"data_friend"]];
            
            NSMutableDictionary *_newHideDict = [[NSMutableDictionary alloc] init];
            [_newHideDict addEntriesFromDictionary:dict];
            [_newHideDict removeObjectForKey:key];
            
            [_newHideDict setObject:_items forKey:key];
            
            [[Configs sharedInstance] saveData:_USER_CONTACTS :_newHideDict];
        }
        
                
        
        [SVProgressHUD showSuccessWithStatus:@"Add Friend Success"];
        
        if ([self.isQR isEqualToString:@"0"]) {
            // AddByID
            NSDictionary *value =  @{@"uid_friend" : uid_friend };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddByID" object:nil userInfo:value];
        }else{
            
            NSDictionary *value =  @{@"uid_friend" : uid_friend };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:value];
        }
        
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [addFriendsThread setErrorHandler:^(NSString *data) {
        NSLog(@"%@", data);
    }];
    [addFriendsThread start:uid_friend];
    
    */
    
    [SVProgressHUD showWithStatus:@"Wait."];
    
    AddFriendThread *addFriendsThread = [[AddFriendThread alloc] init];
    [addFriendsThread setCompletionHandler:^(NSData *data) {
        [[Configs sharedInstance] SVProgressHUD_Dismiss];
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
        
        if ([jsonDict[@"result"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            if ([jsonDict[@"friend_status"] isEqualToString:@"-1"]) {
                [[Configs sharedInstance] SVProgressHUD_ShowErrorWithStatus:jsonDict[@"message"]];
            }else if ([jsonDict[@"friend_status"] isEqualToString:@"99"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
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
    [addFriendsThread start:[jsonDict objectForKey:@"friend_id"]];
    
}

- (IBAction)onClose:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultSearchFriend" object:nil userInfo:@{}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
