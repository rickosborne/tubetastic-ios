//
//  TileView.m
//  TubeTastic
//
//  Created by Rick Osborne on 7/25/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "TileView.h"

@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
            | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.multipleTouchEnabled = NO;
//    self.autoresizesSubviews = YES;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = self.bounds;
    CGContextSetLineWidth(context, frame.size.width * 0.125);
    [[UIColor redColor] set];
    UIRectFrame(frame);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
    // todo
}

@end
