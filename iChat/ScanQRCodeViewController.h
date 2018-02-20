//
//  ScanQRCodeViewController.h
//  Heart
//
//  Created by Somkid on 12/20/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>


@interface ScanQRCodeViewController : UIViewController<ZXCaptureDelegate>
- (IBAction)onClose:(id)sender;

@end
