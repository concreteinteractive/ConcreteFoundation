//
//  CIActivityIndicatorView.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 9/18/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "CIActivityIndicatorView.h"
#import "UIApplication+Concrete.h"
#import "UIView+Concrete.h"

@interface CIActivityIndicatorView()

@end

@implementation CIActivityIndicatorView

- (id)initWithFrame:(CGRect)frame withStyle:(INDICATOR_VIEW_STYLE) style withText:(NSString *) text
{
    if ((self = [super initWithFrame:frame])) {
        if (style == INDICATOR_VIEW_STYLE_BLOCKING) {
            self.backgroundColor = [UIColor clearColor];
            
            UIView* hudView = [[UIView alloc] initWithFrame:CGRectMake(((frame.size.width/2)-(170/2)), ((frame.size.height/2)-(170/2)), 170, 170)];
            hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            hudView.clipsToBounds = YES;
            [hudView setRoundedCorners:UIRectCornerAllCorners radius:10.0];
            [self addSubview:hudView];
            
            CGFloat spinnerY = 50;
            if (text == nil)
            {
                spinnerY += 15;
            }
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            self.activityIndicatorView.frame = CGRectMake(65, spinnerY, self.activityIndicatorView.bounds.size.width, self.activityIndicatorView.bounds.size.height);
            [hudView addSubview:self.activityIndicatorView];
            [self.activityIndicatorView startAnimating];
            
            self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 150, 70)];
            self.captionLabel.backgroundColor = [UIColor clearColor];
            self.captionLabel.textColor = [UIColor whiteColor];
            self.captionLabel.adjustsFontSizeToFitWidth = YES;
            self.captionLabel.numberOfLines = 3;
            self.captionLabel.textAlignment = NSTextAlignmentCenter;
            self.captionLabel.text = text;
            [hudView addSubview:self.captionLabel];
        } else {
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.clipsToBounds = YES;
            
            self.activityIndicatorView.frame = CGRectMake(4, 2, self.activityIndicatorView.bounds.size.width, self.activityIndicatorView.bounds.size.height);
            self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:self.activityIndicatorView];
            [self.activityIndicatorView startAnimating];
            
            self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, frame.size.width-35, 20)];
            self.captionLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
            self.captionLabel.backgroundColor = [UIColor clearColor];
            self.captionLabel.textColor = [UIColor whiteColor];
            self.captionLabel.adjustsFontSizeToFitWidth = YES;
            self.captionLabel.textAlignment = NSTextAlignmentLeft;
            self.captionLabel.text = text;
            [self addSubview:self.captionLabel];
        }
    }
    return self;
}

- (void)updateText:(NSString *) text
{
    self.captionLabel.text = text;
}

@end
