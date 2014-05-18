//
//  SBAIPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIPlayer.h"

#import "SBAIAutomaticShipLayouter.h"
#import "NSArrayExtensions.h"
#import "SBColorExtensions.h"
#import "SBGameFieldCell.h"
#import "SBGameController.h"
#import "SBGameEnviroment.h"

#import "SBAIPlayerShotCellProviderEasy.h"
#import "SBAIPlayerShotCellProviderNormal.h"
#import "SBAIPlayerShotCellProviderHard.h"

@interface SBAIPlayer ()

@property (nonatomic, strong) SBAIAutomaticShipLayouter *shipLayouter;
@property (nonatomic, strong) id<SBAIPlayerShotCellProvider> shotPorvider;
@property (nonatomic, strong) NSArray *userCells;

@end

@implementation SBAIPlayer

- (instancetype)initWithDifficult:(SBAIPlayerDifficult)difficult
{
    self = [super init];
    if (nil != self)
    {
        self.shipLayouter = [SBAIAutomaticShipLayouter new];
        self.info = [SBPlayerInfo new];
        self.info.name = [self nameForDifficult:difficult];
        self.info.avatar = [SBImage imageNamed:@"AIAvatar.png"];
        self.info.color = [SBColor niceGreen];
        
        self.userCells = [NSArray emptyCells];
        self.shotPorvider = [self shotPorviderForDifficult:difficult];
        [self startSetup];
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (NSString *)nameForDifficult:(SBAIPlayerDifficult)difficult
{
    NSString *name = @"";
    switch (difficult)
    {
        case SBAIPlayerDifficultEasy:
            name = @"Easy AI";
            break;
        case SBAIPlayerDifficultNormal:
            name = @"Normal AI";
            break;
        case SBAIPlayerDifficultHard:
            name = @"Hard AI";
            break;
            
        default:break;
    }
    return name;
}

- (id<SBAIPlayerShotCellProvider>)shotPorviderForDifficult:(SBAIPlayerDifficult)difficult
{
    id<SBAIPlayerShotCellProvider> shotProvider = nil;
    switch (difficult)
    {
        case SBAIPlayerDifficultEasy:
            shotProvider = [SBAIPlayerShotCellProviderEasy new];
            break;
        case SBAIPlayerDifficultNormal:
            shotProvider = [SBAIPlayerShotCellProviderNormal new];
            break;
        case SBAIPlayerDifficultHard:
            shotProvider = [SBAIPlayerShotCellProviderHard new];
            break;
            
        default:
            break;
    }
    shotProvider.player = self;
    return shotProvider;
}

- (void)startSetup
{
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        [self.shipLayouter startSetup];
        if ([self.delegate respondsToSelector:@selector(playerDidSetupShips:)])
        {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.delegate playerDidSetupShips:self];
            }];
        }
    }];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(gameDidFinished:) name:kSBGameDidFinishedNotification object:nil];
}

#pragma mark - Player Shot

- (void)shotToCellAtPosition:(SBCellCoordinate)position withResultBlock:(void (^)(SBGameFieldCellState))block
{
    SBGameFieldCell *cell = [self.shipLayouter.cells cellWithPosition:position];
    [self.shipLayouter.cells shotToCellWithPosition:position];
    block(cell.state);
    if (cell.state != SBGameFieldCellStateDefended && cell.state != SBGameFieldCellStateUnderAtack)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shotUser];
        });
    }
}

#pragma mark - AI Shot

- (SBCellCoordinate)coordinateForShot
{
    SBCellCoordinate resultCoordinate = SBCellCoordinateZero;
    NSArray *underAtack = [self.userCells allCellsWithMask:SBGameFieldCellStateUnderAtack];
    if (underAtack.count > 0)
    {
        resultCoordinate = [self.shotPorvider coordinateForShotWithAttackedCells:underAtack];
    }
    else
    {
        resultCoordinate = [self.shotPorvider coordinateForFreeCell];
    }
    return resultCoordinate;
}

- (void)shotUser
{
    NSUInteger defendedCells = [self.userCells allCellsWithMask:SBGameFieldCellStateDefended | SBGameFieldCellStateUnderAtack].count;
    NSUInteger maxCells = [[SBGameEnviroment sharedEnviroment] maxCells];
    if (defendedCells != maxCells)
    {
        NSTimeInterval timeForThink = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForThink * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SBCellCoordinate position = self.coordinateForShot;
            [self shotUserInPosition:position];
        });
    }
}

- (void)shotUserInPosition:(SBCellCoordinate)position
{
    if ([self.delegate respondsToSelector:@selector(player:didShotToCellWithPosition:withResultBlock:)])
    {
        [self.delegate player:self didShotToCellWithPosition:position withResultBlock:^(SBGameFieldCellState state)
        {
            [self.userCells cellWithPosition:position].state = state;
            if (state == SBGameFieldCellStateDefended)
            {
                [self.userCells defendShipWithCoordinate:position];
            }
            
            // If did shot success, shot again
            if (state != SBGameFieldCellStateUnavailable)
            {
                [self shotUser];
            }
        }];
    }
}

- (void)gameDidFinished:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(player:didRespondInformationAboutShipAtPosition:)])
    {
        NSArray *shipCells = [self.shipLayouter.cells allCellsWithMask:SBGameFieldCellStateWithShip];
        for (SBGameFieldCell *cell in shipCells)
        {
            [self.delegate player:self didRespondInformationAboutShipAtPosition:cell.coordinate];
        }
    }
}

@end
