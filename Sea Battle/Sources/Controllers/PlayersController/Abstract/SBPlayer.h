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

@protocol SBPlayerDelegate;

@protocol SBPlayer <NSObject>

@required

@property (nonatomic, weak) IBOutlet id<SBPlayerDelegate> delegate;

- (void)shotToCellAtPosition:(SBCellCoordinate)position withResultBlock:(void (^)(SBGameFieldCellState))block;

@end

@protocol SBPlayerDelegate <NSObject>

- (void)playerDidSetupShips:(id<SBPlayer>)player;

@end