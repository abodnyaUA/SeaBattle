//
//  SBEnviroment.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 4/29/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameController.h"

#import "SBGameFieldCell.h"

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

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
    }
    return self;
}

- (void)initializeGameWithPlayer:(id<SBPlayer>)player;
{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i=0; i<10; i++)
    {
        NSMutableArray *cellsInRow = [NSMutableArray array];
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [SBGameFieldCell cellWithState:SBGameFieldCellStateFree];
            [cellsInRow addObject:cell];
        }
        [cells addObject:[cellsInRow copy]];
    }
    self.userCells = [cells copy];
    self.enemyCells = [cells copy];
    self.enemyPlayer = player;
}

@end
