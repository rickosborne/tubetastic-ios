//
//  TileView.m
//  TubeTastic
//
//  Created by Rick Osborne on 7/25/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "TileView.h"
#import "BoardView.h"

@implementation TileView

@synthesize isAppearing = _isAppearing, isVanishing = _isVanishing, isDropping = _isDropping, isSpinning = _isSpinning, watcher = _watcher, size = _size, renderer = _renderer, tile = _tile;

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
    _padding = 0;
    _tile = nil;
    _renderer = nil;
    _midpoint = 0;
    _size = 0;
    _spinRemain = 0;
    _isSpinning = NO;
    _isAppearing = NO;
    _isDropping = NO;
    _isVanishing = NO;
    _watcher = nil;
    [self setFrame:frame];
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
    if (self.boardView.isWorking && !_isVanishing && !_isDropping && !_isAppearing) {
        if (_isSpinning) {
            _spinRemain++;
        } else {
            _spinRemain = 1;
            if (_watcher) {
                [_watcher tileViewDidStartSpinning:self];
            }
        }
        [_tile spin];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)tile:(BaseTile *)tile powerDidChangeFrom:(Power)fromPower to:(Power)toPower {

}

- (void)tile:(BaseTile *)tile movedFromCol:(int)fromColNum fromRow:(int)fromRowNum toCol:(int)toColNum toRow:(int)toRowNum {
    [self dropToCol:toColNum andRow:toRowNum];
}

- (void)tile:(BaseTile *)tile didSpinFrom:(int)fromDegrees to:(int)toDegrees {
    [self spin];
}

- (void)tileDidVanish:(BaseTile *)tile {
    [self vanish];
}

- (void)dealloc {
    // todo
}

- (void)setTile:(BaseTile *)tile {
    if (_tile) {
        _tile.watcher = nil;
    }
    _tile = tile;
    _tile.watcher = self;
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    _size = frame.size.width;
    _midpoint = floorf(_size * 0.5f);
    _padding = floorf(_size * SIZE_PADDING);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TileView %.0f,%.0f/%.0fx%.0f %@", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, _tile];
}

- (void)spin {
    BoardView *boardView = self.boardView;
    [boardView interruptSweep];
    if (_spinRemain > 0) {
        _isSpinning = YES;
        _tile.power = PowerNone;
        _spinRemain--;
        // todo: animation
    }
    else {
        int newRotation = (int) roundf(0) % 360;
        if (newRotation <= -360) { newRotation += 360; }
        if (newRotation != 0) {
            // todo
        }
        _isSpinning = NO;
        if (_watcher) {
            [_watcher tileViewDidFinishSpinning:self];
        }
        [boardView readyForSweep];
    }
}

- (BoardView *)boardView {
    return (BoardView*)self.superview;
}

- (void)vanish {
    _isVanishing = YES;
    _tile.power = PowerNone;
    if (_watcher) {
        [_watcher tileViewDidStartVanishing:self];
    }
    // todo: animation
}

- (void)dropToCol:(int)colNum andRow:(int)rowNum {
    BoardView *boardView = self.boardView;
    [self dropToCol:colNum andRow:rowNum forX:[boardView xForColNum:colNum] andY:[boardView yForRowNum:rowNum]];
}

- (void)dropToCol:(int)colNum andRow:(int)rowNum forX:(float)x andY:(float)y {
    _isDropping = YES;
    _tile.power = PowerNone;
    if (_watcher) {
        [_watcher tileViewDidStartMoving:self];
    }
    // todo: animation
}

- (void)appear {
    _isAppearing = YES;
    if (_watcher) {
        [_watcher tileViewDidStartAppearing:self];
    }
    // todo: animation
}



@end
