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

@interface SBGameController : NSObject

@property (nonatomic, weak  ) SBGameFieldView *gameFieldView;
@property (nonatomic, strong) NSArray *userCells;

@property (nonatomic, strong) NSArray *enemyCells;
@property (nonatomic, strong) id<SBPlayer> enemyPlayer;

+ (instancetype)sharedController;

- (void)initializeGameWithPlayer:(id<SBPlayer>)player;

@end
