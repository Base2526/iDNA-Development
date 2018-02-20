//
//  KeyboardBar.m
//  KeyboardInputView
//
//  Created by Brian Mancini on 10/4/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "KeyboardBar.h"

@implementation KeyboardBar

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate {
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (id)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 50);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, frame.size.width - 70, frame.size.height - 10)];
        self.textView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        [self addSubview:self.textView];
        
        self.actionButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60, 5, 55, frame.size.height - 10)];
        self.actionButton.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.actionButton.layer.cornerRadius = 2.0;
        self.actionButton.layer.borderWidth = 1.0;
        self.actionButton.layer.borderColor = [[UIColor colorWithWhite:0.45 alpha:1.0f] CGColor];
        [self.actionButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(didTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.actionButton];
        
        
        /*
        // http://stackoverflow.com/questions/16049009/uiview-autoresizingmask-for-fixed-left-and-right-margin-and-flexible-width
        // CGRect bounds = self.bounds; // get bounds of parent view
        CGRect subviewFrame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40);
        UIView *subview = [[UIView alloc] initWithFrame:subviewFrame];
        subview.backgroundColor = [UIColor blueColor];
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, subview.frame.size.width - 70, subview.frame.size.height - 10)];
        self.textView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        [subview addSubview:self.textView];
        
        self.actionButton = [[UIButton alloc]initWithFrame:CGRectMake(subview.frame.size.width - 60, 5, 55, subview.frame.size.height - 10)];
        self.actionButton.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.actionButton.layer.cornerRadius = 2.0;
        self.actionButton.layer.borderWidth = 1.0;
        self.actionButton.layer.borderColor = [[UIColor colorWithWhite:0.45 alpha:1.0f] CGColor];
        [self.actionButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(didTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
        [subview addSubview:self.actionButton];
        
        [self addSubview:subview];
         */
        
        
        // create hooks for keyboard
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardDidShowOrHide:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardDidShowOrHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
        
        // Listen for keyboard appearances and disappearances
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardDidShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardDidHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
        
        // [self registerForKeyboardNotifications];

    }
    return self;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    NSLog(@"");
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //scrollView.contentInset = contentInsets;
    // scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) didTouchAction
{
    [self.delegate keyboardBar:self sendText:self.textView.text];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
