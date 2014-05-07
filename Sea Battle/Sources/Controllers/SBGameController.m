//
//  SBEnviroment.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/29/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameController.h"

#import "SBGameFieldCell.h"
#import "NSArray+SBGameFieldCell.h"

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
    self.gameStarted = NO;
    self.activePlayer = SBActivePlayerUser;
}



@end
