//
//  ViewImageView.m
//  Heart
//
//  Created by Somkid on 12/23/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import "ViewImageView.h"
#import "AppDelegate.h"

@interface ViewImageView ()
@end

@implementation ViewImageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if (![self.profile_picture isEqualToString:@""]) {
    [self.hjmImage clear];
    [self.hjmImage showLoadingWheel];
    
    if (self.image == nil) {
        [self.hjmImage setUrl:[NSURL URLWithString:self.uri]];
    }else{
        [self.hjmImage setImage:self.image];
    }
    
    // [img setImage:[UIImage imageWithData:fileData]];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] obj_Manager ] manage:self.hjmImage];
    
}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
