//
//  CIPlaceholderTextView.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/23/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import "CIPlaceholderTextView.h"

@implementation CIPlaceholderTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.placeholder = @"";
    self.placeholderColor = [UIColor darkGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged:(NSNotification *)notification
{
    if ([self.text length] == 0)
    {
        self.placeHolderLabel.alpha = 1;
    } else {
        self.placeHolderLabel.alpha = 0;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if ([self.placeholder length] > 0)
    {
        if (self.placeHolderLabel == nil)
        {
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.alpha = 0;
            [self addSubview:self.placeHolderLabel];
        }
        
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    [super drawRect:rect];
}

@end
