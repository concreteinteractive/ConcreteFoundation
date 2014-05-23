//
//  CIPlaceholderTextView.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/23/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIPlaceholderTextView : UITextView

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
