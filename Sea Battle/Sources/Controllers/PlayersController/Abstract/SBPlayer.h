//
//  SBPlayer.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBGameFieldCell.h"
#import "SBCellCoordinate.h"
#import "SBPlayerInfo.h"

typedef void (^SBShotResultBlock)(SBGameFieldCellState);

@protocol SBPlayerDelegate;

@protocol SBPlayer <NSObject>

@required

@property (nonatomic, weak) IBOutlet id<SBPlayerDelegate> delegate;
@property (nonatomic, strong) SBPlayerInfo *info;

- (void)shotToCellAtPosition:(SBCellCoordinate)position withResultBlock:(SBShotResultBlock)block;

@end

@protocol SBPlayerDelegate <NSObject>

- (void)playerDidSetupShips:(id<SBPlayer>)player;
- (void)player:(id<SBPlayer>)player didShotToCellWithPosition:(SBCellCoordinate)position withResultBlock:(SBShotResultBlock)block;
- (void)player:(id<SBPlayer>)player didRespondInformationAboutShipAtPosition:(SBCellCoordinate)position;

@end