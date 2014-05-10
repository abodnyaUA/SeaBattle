//
//  SBEnviroment.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/29/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBGameFieldView.h"
#import "SBShipPositionController.h"
#import "SBPlayer.h"

NSString * const kSBGameDidFinishedNotification;

typedef NS_ENUM(NSUInteger, SBGameFinishingReason)
{
    SBGameFinishingReasonUserWins = 0,
    SBGameFinishingReasonOponentWins,
    SBGameFinishingReasonUserLeave,
    SBGameFinishingReasonOponentLeave
};

typedef NS_ENUM(NSUInteger, SBGameState)
{
    SBGameStateWaitingPlayers = 0,
    SBGameStateReadyUser      = 1 << 0,
    SBGameStateReadyOponent   = 1 << 1,
    SBGameStateReady = SBGameStateReadyUser | SBGameStateReadyOponent
};

typedef NS_ENUM(NSUInteger, SBActivePlayer)
{
    SBActivePlayerUser = 0,
    SBActivePlayerOpponent
};

@interface SBGameController : NSObject

@property (nonatomic, weak  ) SBGameFieldView *gameFieldView;
@property (nonatomic, strong) NSArray *userCells;

@property (nonatomic, strong) NSArray *enemyCells;
@property (nonatomic, strong) id<SBPlayer> enemyPlayer;

@property (nonatomic, assign) SBGameState gameState;
@property (nonatomic, assign) SBActivePlayer activePlayer;

+ (instancetype)sharedController;

- (void)initializeGameWithPlayer:(id<SBPlayer>)player;
- (void)checkGameEnd;
- (BOOL)gameStarted;

@end
