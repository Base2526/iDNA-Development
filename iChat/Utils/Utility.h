//
//  Utils.h
//  Heart
//
//  Created by Somkid on 2/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (UIColor *)colorDefualt;
+ (CGRect)maximumSquareFrameThatFits:(CGRect)frame;
+ (UIBezierPath *)heartShape:(CGRect)originalFrame;
+ (BOOL) isKeyboardOnScreen;

+ (UIImageView *) makeImageTriangular: (UIImageView *) imageView;
+ (UIImageView *) makeImageTriangular: (UIImageView *) imageView :(UIColor *)color;

+ (UIImageView *) makeImageCornerRadius: (UIImageView *) imageView;

+(void)roundView:(UIView *)view onCorner:(UIRectCorner)rectCorner radius:(float)radius;

+(float) statusBarHeight;

+(NSString*)base64forData:(NSData*) theData;
@end
