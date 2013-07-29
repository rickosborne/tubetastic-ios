//
// Created by Rick Osborne on 7/27/13.
// Copyright (c) 2013 rick osborne dot org. All rights reserved.
//


#import "TileView.h"
#import "BoardView.h"
#import "ScoreKeeper.h"
#import "GamePrefs.h"
#import "TileChange.h"
#import "ScoreBoardView.h"
#import "BoardViewEventListener.h"
#import "TubeTile.h"

static const float SCORE_HEIGHT = 0.08f;
static const double DELAY_SWEEP = 0.125;

@implementation BoardView {
@protected
    BOOL _ready;
    BOOL _awaitingSweep;
    NSUInteger _colCount;
    NSUInteger _rowCount;
    NSUInteger _animatableCount;
    NSMutableSet *_dropping;
    NSMutableSet *_spinning;
    NSMutableSet *_appearing;
    NSMutableSet *_vanishing;
    NSMutableArray* _tileViews;
    UIColor *_colorSource;
    UIColor *_colorSink;
    UIColor *_colorArc;
    UIColor *_colorNone;
    TileChangeSet *_tileChanges;
    NSUInteger _tileSize;
    CGRect _bounds;
@private
    GameBoard *_gameBoard;
    ScoreKeeper *_scoreKeeper;
    ScoreBoardView *_scoreBoard;
    NSTimer *_sweepTimer;
    NSMutableSet *_eventListeners;
}

@synthesize gameBoard = _gameBoard;
@synthesize scoreKeeper = _scoreKeeper;

- (BoardView *)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) { return self; }
    _colorSource = GamePrefs.COLOR_POWER_SOURCED;
    _colorSink   = GamePrefs.COLOR_POWER_SUNK;
    _colorNone   = GamePrefs.COLOR_POWER_NONE;
    _colorArc    = GamePrefs.COLOR_ARC;
    _ready = NO;
    _awaitingSweep = NO;
    _eventListeners = [[NSMutableSet alloc] init];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resizeToFitFrame:frame];
}

- (float)fixScoreBoard {
    float scoreHeight = 0;
    if (!_scoreKeeper) {
        if (_scoreBoard) {
            [_scoreBoard removeFromSuperview];
            _scoreBoard = nil;
        }
    } else {
        scoreHeight = self.frame.size.height * SCORE_HEIGHT;
        CGRect scoreFrame = CGRectMake(0, self.frame.size.height - scoreHeight, self.frame.size.width, scoreHeight);
        if (!_scoreBoard) {
            _scoreBoard = [[ScoreBoardView alloc] initWithFrame:scoreFrame];
        } else {
            _scoreBoard.frame = scoreFrame;
        }
    }
    return scoreHeight;
}

- (void)resizeToFitFrame:(CGRect)frame {
    float scoreHeight = [self fixScoreBoard];
    float availableHeight = frame.size.height - scoreHeight;
    _tileSize = (NSUInteger) floorf(fminf(frame.size.width / _colCount, availableHeight / _rowCount));
    float w = roundf(_colCount * _tileSize);
    float h = roundf((_rowCount * _tileSize) + scoreHeight);
    float x = frame.origin.x + (frame.size.width - w) * 0.5f;
    float y = frame.origin.y + (frame.size.height - h) * 0.5f;
    _bounds = CGRectMake(x, y, w, h);
}

- (void)setGameBoard:(GameBoard *)gameBoard {
    _gameBoard = gameBoard;
    _colCount = gameBoard.colCount;
    _rowCount = gameBoard.rowCount;
    _animatableCount = (_colCount - 2) * _rowCount;
    _dropping  = [[NSMutableSet alloc] initWithCapacity:_animatableCount];
    _appearing = [[NSMutableSet alloc] initWithCapacity:_animatableCount];
    _vanishing = [[NSMutableSet alloc] initWithCapacity:_animatableCount];
    _spinning  = [[NSMutableSet alloc] initWithCapacity:_animatableCount];
    _tileViews = [[NSMutableArray alloc] initWithCapacity:_rowCount * _colCount];
    for (NSUInteger tileNum = 0; tileNum < _rowCount * _colCount; tileNum++) {
        [_tileViews addObject:NSNull.null];
    }
    _gameBoard.watcher = self;
}

- (NSUInteger)indexForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    return (rowNum * _colCount) + colNum;
}

- (TileView *)getTileViewForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    if ((colNum < _colCount) && (rowNum < _rowCount)) {
        NSObject *tile = [_tileViews objectAtIndex:[self indexForCol:colNum andRow:rowNum]];
        return (tile && [tile isKindOfClass:TileView.class]) ? (TileView *)tile : nil;
    }
    return nil;
}

- (void)setTileView:(TileView *)tileView forCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum {
    if ((colNum < _colCount) && (rowNum < _rowCount)) {
        NSObject *tileObject = tileView ? NSNull.null : tileView;
        [_tileViews replaceObjectAtIndex:[self indexForCol:colNum andRow:rowNum] withObject:tileObject];
    }
}

- (void)randomizeTiles {
    _ready = NO;
    [_gameBoard randomizeTiles];
    [self addGameViews];
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            [[self getTileViewForCol:colNum andRow:rowNum] appear];
        }
    }
    [self notifyListenersOfEvent:BoardViewEventBoardWasRandomized];
    _ready = YES;
}

- (void)begin {
    _awaitingSweep = YES;
    [self powerSweep];
    [self notifyListenersOfEvent:BoardViewEventBoardDidSettle];
}

- (BOOL)float:(float)a isWithin:(float)epsilon ofFloat:(float)b {
    return (fabsf(a - b) <= epsilon);
}

- (void)powerSweep {
    [self stopSweepTimer];
    if (!_awaitingSweep || ![self isWorking]) { return; }
    _awaitingSweep = NO;
    _tileChanges = [_gameBoard powerSweep];
    if (!_tileChanges) {
        _ready = YES;
        return;
    }
    NSUInteger vanishCount = _tileChanges.vanished.count;
    if (!vanishCount) {
        _ready = YES;
        return;
    }
    if (vanishCount == _animatableCount) {
        [self notifyListenersOfEvent:BoardViewEventBoardWillVanish];
    }
    if ([self notifyListenersOfEvent:BoardViewEventTilesWillAppear] != BoardViewEventResponseYeahIHandledThatForYou) {
        _ready = NO;
        for (TileChangeAppear *appearance in _tileChanges.appeared) {
            EmptyTile *tile = [_gameBoard tileForCol:appearance.colNum andRow:appearance.rowNum];
            if (tile && !tile.isEmpty) {
                [[self createTileViewForCol:appearance.colNum andRow:appearance.rowNum withTile:(BaseTile *)tile] appear];
            }
        }
    }
}

- (BOOL)isAnimating {
    return (_spinning.count > 0) || self.isWorking;
}

- (BOOL)isWorking {
    return (_dropping.count > 0) || (_vanishing.count > 0) || (_appearing.count > 0);
}

- (void)stopSweepTimer {
    if (_sweepTimer) {
        [_sweepTimer invalidate];
        _sweepTimer = nil;
    }
}

- (void)interruptSweep {
    _awaitingSweep = NO;
    [self stopSweepTimer];
}

- (void)readyForSweep {
    _awaitingSweep = YES;
    [self stopSweepTimer];
    _sweepTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_SWEEP target:self selector:@selector(powerSweep) userInfo:nil repeats:NO];
}

- (void)setScoreKeeper:(ScoreKeeper *)scoreKeeper {
    _scoreKeeper = scoreKeeper;
    [self resizeToFitFrame:self.frame];
    if (_scoreKeeper) {
        NSUInteger score = _gameBoard.score;
        if (score > 0) {
            [_scoreKeeper addScore:score];
            _scoreBoard.score = score;
        }
    }
}

- (float)xForColNum:(NSUInteger)colNum {
    return _bounds.origin.x + (colNum * _tileSize);
}

- (float)yForRowNum:(NSUInteger)rowNum {
    return _bounds.origin.y + (rowNum * _tileSize);
}

- (void)addBoardViewEventListener:(id<BoardViewEventListener>)listener {
    if (![_eventListeners containsObject:listener]) {
        [_eventListeners addObject:listener];
    }
}

- (BoardViewEventResponse)notifyListenersOfEvent:(BoardViewEvent)event {
    BoardViewEventResponse response = BoardViewEventResponseNoReaction;
    for (id<BoardViewEventListener> listener in _eventListeners) {
        switch (event) {
            case BoardViewEventBoardWasRandomized:
                if ([listener respondsToSelector:@selector(boardWasRandomized)]) {
                    response = [listener boardWasRandomized];
                }
                break;
            case BoardViewEventBoardDidSettle:
                if ([listener respondsToSelector:@selector(boardDidSettle)]) {
                    response = [listener boardDidSettle];
                }
                break;
            case BoardViewEventBoardWillVanish:
                if ([listener respondsToSelector:@selector(boardWillVanish)]) {
                    response = [listener boardWillVanish];
                }
                break;
            case BoardViewEventTilesWillAppear:
                if ([listener respondsToSelector:@selector(tilesWillAppear)]) {
                    response = [listener tilesWillAppear];
                }
                break;
            case BoardViewEventTilesWillVanish:
                if ([listener respondsToSelector:@selector(tilesWillVanish)]) {
                    response = [listener tilesWillVanish];
                }
                break;
            case BoardViewEventTilesDidVanish:
                if ([listener respondsToSelector:@selector(tilesDidVanish)]) {
                    response = [listener tilesDidVanish];
                }
                break;
        }
    }
    return response;
}

- (BoardViewEventResponse)notifyListenersOfEvent:(BoardViewEvent)event forTile:(TubeTile *)tile {
    BoardViewEventResponse response = BoardViewEventResponseNoReaction;
    for (id<BoardViewEventListener> listener in _eventListeners) {
        switch (event) {
            case BoardViewEventTileWillSpin:
                if ([listener respondsToSelector:@selector(tileWillSpin:)]) {
                    response = [listener tileWillSpin:tile];
                }
                break;
        }
    }
    return response;
}

- (TileView *)createTileViewForCol:(NSUInteger)colNum andRow:(NSUInteger)rowNum withTile:(BaseTile *)tile {
    TileView *tileView = [[TileView alloc] initWithFrame:CGRectMake([self xForColNum:colNum], [self yForRowNum:rowNum], _tileSize, _tileSize)];
    [tileView setTile:tile];
    tileView.watcher = self;
    [self setTileView:tileView forCol:colNum andRow:rowNum];
    [self addSubview:tileView];
    return tileView;
}

- (void)addGameViews {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self fixScoreBoard];
    for (NSUInteger rowNum = 0; rowNum < _rowCount; rowNum++) {
        for (NSUInteger colNum = 0; colNum < _colCount; colNum++) {
            TileView *tileView = [self getTileViewForCol:colNum andRow:rowNum];
            EmptyTile *tile = [_gameBoard tileForCol:colNum andRow:rowNum];
            if (tileView && (tileView.tile == tile)) {
                [self addSubview:tileView];
            } else {
                if (tile && !tile.isEmpty) {
                    [self createTileViewForCol:colNum andRow:rowNum withTile:(BaseTile *)tile];
                }
            }
        }
    }
}

- (void)scoreDidChangeFrom:(NSUInteger)fromScore to:(NSUInteger)toScore {
    if (_scoreKeeper) {
        [_scoreKeeper addScore:toScore];
    }
    if (_scoreBoard) {
        _scoreBoard.score = toScore;
    }
}

- (void)tileViewDidStartSpinning:(TileView *)tileView {
    _ready = NO;
    [_spinning addObject:tileView];
}

- (void)tileViewDidFinishSpinning:(TileView *)tileView {
    [_spinning removeObject:tileView];
    _ready = !self.isAnimating;
}

- (void)tileViewDidStartVanishing:(TileView *)tileView {
    if (_vanishing.count == 0) {
        [self notifyListenersOfEvent:BoardViewEventTilesWillVanish];
    }
    _ready = NO;
    [_vanishing addObject:tileView];
}

- (void)tileViewDidFinishVanishing:(TileView *)tileView {
    [_vanishing removeObject:tileView];
    _ready = !self.isAnimating;
    if (_vanishing.count == 0) {
        [self notifyListenersOfEvent:BoardViewEventTilesDidVanish];
    }
}

- (void)tileViewDidStartMoving:(TileView *)tileView {
    _ready = NO;
    [_dropping addObject:tileView];
}

- (void)tileViewDidFinishMoving:(TileView *)tileView {
    [_dropping removeObject:tileView];
    _ready = !self.isAnimating;
    [self setTileView:tileView forCol:tileView.tile.colNum andRow:tileView.tile.rowNum];
}

- (void)tileViewDidStartAppearing:(TileView *)tileView {
    _ready = NO;
    [_appearing addObject:tileView];
}

- (void)tileViewDidFinishAppearing:(TileView *)tileView {
    [_appearing removeObject:tileView];
    _ready = !self.isAnimating;
    [self setTileView:tileView forCol:tileView.tile.colNum andRow:tileView.tile.rowNum];
    if (_appearing.count == 0) {
        [self readyForSweep];
    }
}


@end