//
//  SBAIPlayer.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBPlayer.h"

@protocol SBAIPlayerShotCellProvider;

typedef NS_ENUM(NSUInteger, SBAIPlayerDifficult)
{
    SBAIPlayerDifficultEasy = 0,
    SBAIPlayerDifficultNormal,
    SBAIPlayerDifficultHard
};

@interface SBAIPlayer : NSObject <SBPlayer>

@property (nonatomic, weak) id<SBPlayerDelegate> delegate;
@property (nonatomic, strong) SBPlayerInfo *info;

// Private
@property (nonatomic, strong, readonly) NSArray *userCells;

- (instancetype)initWithDifficult:(SBAIPlayerDifficult)difficult;

@end

@protocol SBAIPlayerShotCellProvider <NSObject>

@required

@property (nonatomic, weak) SBAIPlayer *player;

- (SBCellCoordinate)coordinateForShotWithAttackedCells:(NSArray *)underAtack;
- (SBCellCoordinate)coordinateForFreeCell;

@end
