//
//  CIActivityIndicatorView.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 9/18/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    INDICATOR_VIEW_STYLE_BANNER,
    INDICATOR_VIEW_STYLE_BLOCKING
}INDICATOR_VIEW_STYLE;

@interface CIActivityIndicatorView : UIView

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, strong) UILabel* captionLabel;
@property (nonatomic) INDICATOR_VIEW_STYLE style;

- (id)initWithFrame:(CGRect)frame withStyle:(INDICATOR_VIEW_STYLE) style withText:(NSString *) text;
- (void)updateText:(NSString *) text;

@end
