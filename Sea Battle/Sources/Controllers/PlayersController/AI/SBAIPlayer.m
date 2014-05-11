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
#import "SBGameFieldCell.h"
#import "SBGameController.h"
#import "SBGameEnviroment.h"

@interface SBAIPlayer ()

@property (nonatomic, strong) SBAIAutomaticShipLayouter *shipLayouter;
@property (nonatomic, strong) NSArray *userCells;

- (SBCellCoordinate)coordinateForShotWithAttackedCells:(NSArray *)underAtack;
- (SBCellCoordinate)coordinateForFreeCell;

@end

@implementation SBAIPlayer

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        self.shipLayouter = [SBAIAutomaticShipLayouter new];
        self.info = [SBPlayerInfo new];
        self.info.name = @"AI Player";
        self.info.avatar = [UIImage imageNamed:@"AIAvatar.png"];
        self.userCells = [NSArray emptyCells];
        [self startSetup];
    }
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
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
    [self.shipLayouter.cells printShips];
    //TODO: Remove this shit
    if (cell.state != SBGameFieldCellStateDefended && cell.state != SBGameFieldCellStateUnderAtack)
    {
        [self shotUser];
    }
}

#pragma mark - AI Shot

- (SBCellCoordinate)coordinateForShot
{
    SBCellCoordinate resultCoordinate = SBCellCoordinateZero;
    NSArray *underAtack = [self.userCells allCellsWithMask:SBGameFieldCellStateUnderAtack];
    if (underAtack.count > 0)
    {
        resultCoordinate = [self coordinateForShotWithAttackedCells:underAtack];
    }
    else
    {
        resultCoordinate = [self coordinateForFreeCell];
    }
    return resultCoordinate;
}

- (SBCellCoordinate)coordinateForFreeCell
{
    [NSException raise:@"Method Is Not Implemented" format:@"Please use Easy, Normal or Hard subclasses!"];
    return SBCellCoordinateZero;
}

- (SBCellCoordinate)coordinateForShotWithAttackedCells:(NSArray *)underAtack
{
    [NSException raise:@"Method Is Not Implemented" format:@"Please use Easy, Normal or Hard subclasses!"];
    return SBCellCoordinateZero;
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
