//
//  Utils.m
//  Heart
//
//  Created by Somkid on 2/2/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "Utility.h"


@implementation Utility

+ (UIColor *)colorDefualt{
    // return [UIColor colorWithRed:0.96 green:0.06 blue:0.31 alpha:1.0];
    
    return [UIColor colorWithRed:0.90 green:0.88 blue:0.88 alpha:1.0];
}

+ (CGRect)maximumSquareFrameThatFits:(CGRect)frame;
{
    CGFloat a = MIN(frame.size.width, frame.size.height);
    return CGRectMake(frame.size.width/2 - a/2, frame.size.height/2 - a/2, a, a);
}

+ (UIBezierPath *)heartShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49986 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24129 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.64732 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05022 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55044 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11201 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33067 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06393 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46023 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14682 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39785 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08864 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05011 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30516 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05454 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27896 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04999 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36081 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.12805 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05067 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.00977 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15998 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29627 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70379 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.00709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55420 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.18069 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62648 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50061 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92498 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40835 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77876 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48812 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88133 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70195 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70407 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50990 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88158 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59821 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77912 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.99177 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35870 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.81539 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62200 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.99308 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55208 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.99040 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15672 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86824 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04848 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

+ (BOOL) isKeyboardOnScreen
{
    BOOL isKeyboardShown = NO;
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count > 1) {
        NSArray *wSubviews =  [windows[1]  subviews];
        if (wSubviews.count) {
            CGRect keyboardFrame = [wSubviews[0] frame];
            CGRect screenFrame = [windows[1] frame];
            if (keyboardFrame.origin.y+keyboardFrame.size.height == screenFrame.size.height) {
                isKeyboardShown = YES;
            }
        }
    }
    
    return isKeyboardShown;
}

+ (UIImageView *) makeImageTriangular: (UIImageView *) imageView{
    
    /*
     ทำการ crop รูป หกเหลี่ยม
     */
    // https://stackoverflow.com/questions/27062893/create-a-uiimage-or-uiimageview-with-hexagonal-corners
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = imageView.bounds;
    
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    // maskLayer.path = path.CGPath;
    
    UIGraphicsEndImageContext();
    
    // self.layer.mask = maskLayer;
    
    // 2. Create a CAShapeLayer with this triangular path
    // Same size as the original imageView
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = imageView.bounds;
    mask.path = path.CGPath;
    
    
    // 3. Mask the imageView's layer with this shape
    imageView.layer.mask = mask;
    
    /*
     วาดเส้นกรอบสีแดง
     https://stackoverflow.com/questions/36174991/ios-uiimageview-border-white-with-radius-display-a-strange-dark-line-in-4-corne
     */
    CAShapeLayer*   frameLayer = [CAShapeLayer layer];
    frameLayer.frame = imageView.bounds;
    frameLayer.path = path.CGPath;
    frameLayer.strokeColor = [UIColor colorWithRed:0.96 green:0.06 blue:0.31 alpha:1.0].CGColor;//[UIColor redColor].CGColor;
    frameLayer.fillColor = nil;
    frameLayer.lineWidth = 5;
    [imageView.layer addSublayer:frameLayer];
    
    return imageView;
}

+ (UIImageView *) makeImageTriangular: (UIImageView *) imageView :(UIColor*)color{
    
    /*
     ทำการ crop รูป หกเหลี่ยม
     */
    // https://stackoverflow.com/questions/27062893/create-a-uiimage-or-uiimageview-with-hexagonal-corners
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = imageView.bounds;
    
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path closePath];
    [path fill];
    [path stroke];
    
    // maskLayer.path = path.CGPath;
    
    UIGraphicsEndImageContext();
    
    // self.layer.mask = maskLayer;
    
    // 2. Create a CAShapeLayer with this triangular path
    // Same size as the original imageView
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = imageView.bounds;
    mask.path = path.CGPath;
    
    
    // 3. Mask the imageView's layer with this shape
    imageView.layer.mask = mask;
    
    /*
     วาดเส้นกรอบสีแดง
     https://stackoverflow.com/questions/36174991/ios-uiimageview-border-white-with-radius-display-a-strange-dark-line-in-4-corne
     */
    CAShapeLayer*   frameLayer = [CAShapeLayer layer];
    frameLayer.frame = imageView.bounds;
    frameLayer.path = path.CGPath;
    frameLayer.strokeColor = color.CGColor;//[UIColor colorWithRed:0.96 green:0.06 blue:0.31 alpha:1.0].CGColor;//[UIColor redColor].CGColor;
    frameLayer.fillColor = nil;
    frameLayer.lineWidth = 1;
    [imageView.layer addSublayer:frameLayer];
    
    return imageView;
}

+(void)roundView:(UIView *)view onCorner:(UIRectCorner)rectCorner radius:(float)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    [view.layer setMask:maskLayer];
}


+(float) statusBarHeight
{
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}


+(NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
