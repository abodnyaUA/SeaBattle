//
//  SBEnviroment.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/29/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameController.h"

#import "SBGameFieldCell.h"
#import "NSArrayExtensions.h"
#import "SBGameEnviroment.h"

NSString * const kSBGameDidFinishedNotification = @"kSBGameDidFinishedNotification";

@implementation SBGameController

+ (instancetype)sharedController
{
    static dispatch_once_t onceToken;
    static SBGameController *enviroment;
    dispatch_once(&onceToken, ^{
        enviroment = [SBGameController new];
    });
    return enviroment;
}

- (void)initializeGameWithPlayer:(id<SBPlayer>)player;
{
    self.userCells = [NSArray emptyCells];
    self.enemyCells = [NSArray emptyCells];
    self.enemyPlayer = player;
    self.gameState = SBGameStateWaitingPlayers;
    self.activePlayer = SBActivePlayerUser;
    self.gameState = SBGameStateWaitingPlayers;
}

- (BOOL)gameStarted
{
    return self.gameState == SBGameStateReady;
}

- (void)checkGameEnd
{
    NSUInteger maxCells = [[SBGameEnviroment sharedEnviroment] maxCells];
    NSArray *userDefendedCells = [self.userCells allCellsWithMask:SBGameFieldCellStateDefended];
    NSArray *oponentDefendedCells = [self.enemyCells allCellsWithMask:SBGameFieldCellStateDefended];
    if (userDefendedCells.count == maxCells)
    {
        [self notifyAboutFinishingGameWithReason:SBGameFinishingReasonOponentWins];
    }
    else if (oponentDefendedCells.count == maxCells)
    {
        [self notifyAboutFinishingGameWithReason:SBGameFinishingReasonUserWins];
    }
}

- (void)notifyAboutFinishingGameWithReason:(SBGameFinishingReason)reason
{
    [NSNotificationCenter.defaultCenter postNotificationName:kSBGameDidFinishedNotification object:nil userInfo:@{@"reason" : @(reason)}];
}

@end
