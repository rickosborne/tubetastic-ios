//
//  TileView.m
//  TubeTastic
//
//  Created by Rick Osborne on 7/25/13.
//  Copyright (c) 2013 rick osborne dot org. All rights reserved.
//

#import "TileView.h"
#import "BoardView.h"
#import "TileRenderer.h"
#import "TubeTile.h"

@implementation TileView {
}

static TileView *singleton = nil;

@synthesize isAppearing = _isAppearing, isVanishing = _isVanishing, isDropping = _isDropping, isSpinning = _isSpinning, watcher = _watcher, size = _size, tile = _tile;

+ (void)initialize {
    if (!singleton) {
        singleton = [[TileView alloc] init];
        singleton.SIZE_PADDING    = 1.0 / 16.0;
        singleton.SIZE_ARCWIDTH   = 1.0 / 8.0;
        singleton.DURATION_VANISH = 0.500;
        singleton.DURATION_DROP   = 0.250;
        singleton.DURATION_APPEAR = singleton.DURATION_VANISH + singleton.DURATION_DROP;
        singleton.DURATION_SPIN   = 0.150;
        singleton.DEGREES_SPIN    = (float) M_PI_2;
        singleton.DEGREES_CIRCLE  = -360;
        singleton.OPACITY_VANISH  = 0;
        singleton.OPACITY_APPEAR  = 1;
        singleton.SCALE_VANISH    = 0;
        singleton.SCALE_APPEAR    = 1;
    }
}

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
    _padding = 0;
    _tile = nil;
    _midpoint = 0;
    _size = 0;
    _spinRemain = 0;
    _isSpinning = NO;
    _isAppearing = NO;
    _isDropping = NO;
    _isVanishing = NO;
    _watcher = nil;
    _totalSpins = 0;
    [self setFrame:frame];
    self.backgroundColor = UIColor.clearColor;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [TileRenderer drawTile:_tile inContext:UIGraphicsGetCurrentContext() withBounds:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (([_tile isKindOfClass:TubeTile.class]) && !self.boardView.isWorking && !_isVanishing && !_isDropping && !_isAppearing) {
        if (_isSpinning) {
            _spinRemain++;
        } else {
            _spinRemain = 1;
            if (_watcher) {
                [_watcher tileViewDidStartSpinning:self];
            }
        }
        _totalSpins++;
        [_tile spin];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)tile:(BaseTile *)tile powerDidChangeFrom:(Power)fromPower to:(Power)toPower {

}

- (void)tile:(BaseTile *)tile movedFromCol:(NSUInteger)fromColNum fromRow:(NSUInteger)fromRowNum toCol:(NSUInteger)toColNum toRow:(NSUInteger)toRowNum {
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
    _padding = floorf(_size * TileView.SIZE_PADDING);
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
        [UIView animateWithDuration:TileView.DURATION_SPIN delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = CGAffineTransformMakeRotation(TileView.DEGREES_SPIN * _totalSpins);
        } completion:^(BOOL finished){
            [self spin];
        }];
    }
    else {
        _totalSpins %= 4;
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
    [UIView animateWithDuration:TileView.DURATION_VANISH delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(self.frame.origin.x + (self.frame.size.width * 0.5), self.frame.origin.y + (self.frame.size.height * 0.5), 0, 0);
        self.alpha = TileView.OPACITY_VANISH;
    } completion:^(BOOL finished){
        [_watcher tileViewDidFinishVanishing:self];
    }];
}

- (void)dropToCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    BoardView *boardView = self.boardView;
    [self dropToCol:colNum andRow:rowNum forX:[boardView xForColNum:colNum] andY:[boardView yForRowNum:rowNum]];
}

- (void)dropToCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum forX:(float)x andY:(float)y {
    _isDropping = YES;
    _tile.power = PowerNone;
    if (_watcher) {
        [_watcher tileViewDidStartMoving:self];
    }
    [UIView animateWithDuration:TileView.DURATION_DROP delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){
        _isDropping = NO;
        [_watcher tileViewDidFinishMoving:self];
    }];
}

- (void)appear {
    _isAppearing = YES;
    if (_watcher) {
        [_watcher tileViewDidStartAppearing:self];
    }
    const CGRect origFrame = self.frame;
    self.alpha = TileView.OPACITY_VANISH;
    self.frame = CGRectMake(self.frame.origin.x + (self.frame.size.width * 0.5), self.frame.origin.y + (self.frame.size.height * 0.5), 0, 0);
    [UIView animateWithDuration:TileView.DURATION_APPEAR delay:0.125 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = origFrame;
        self.alpha = TileView.OPACITY_APPEAR;
    } completion:^(BOOL finished){
        _isAppearing = NO;
        [_watcher tileViewDidFinishAppearing:self];
    }];
}

+ (float)SIZE_PADDING { return singleton.SIZE_PADDING; }
+ (float)SIZE_ARCWIDTH { return singleton.SIZE_ARCWIDTH; }
+ (float)DURATION_VANISH { return singleton.DURATION_VANISH; }
+ (float)DURATION_DROP { return singleton.DURATION_DROP; }
+ (float)DURATION_APPEAR { return singleton.DURATION_APPEAR; }
+ (float)DURATION_SPIN { return singleton.DURATION_SPIN; }
+ (float)DEGREES_SPIN { return singleton.DEGREES_SPIN; }
+ (float)DEGREES_CIRCLE { return singleton.DEGREES_CIRCLE; }
+ (float)OPACITY_VANISH { return singleton.OPACITY_VANISH; }
+ (float)OPACITY_APPEAR { return singleton.OPACITY_APPEAR; }
+ (float)SCALE_VANISH { return singleton.SCALE_VANISH; }
+ (float)SCALE_APPEAR { return singleton.SCALE_APPEAR; }

@end
