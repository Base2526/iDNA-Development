//
//  CustomTapGestureRecognizer.h
//  iDNA
//
//  Created by Somkid on 24/1/2561 BE.
//  Copyright © 2561 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// https://stackoverflow.com/questions/27348917/objective-c-passing-a-string-parameter-to-tapgesture-selector
@interface CustomTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) NSObject * object;
@end
