//
//  SBAIEasyPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/11/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIPlayerShotCellProviderEasy.h"
#import "NSArrayExtensions.h"

@implementation SBAIPlayerShotCellProviderEasy

- (SBCellCoordinate)coordinateForShot
{
    NSArray *avaiableCells = [self.player.userCells allCellsWithMask:SBGameFieldCellStateFree];
    SBGameFieldCell *randomCell = [avaiableCells objectAtIndex:arc4random() % avaiableCells.count];
    return randomCell.coordinate;
}

- (SBCellCoordinate)coordinateForShotWithAttackedCells:(NSArray *)underAtack
{
    return [self coordinateForShot];
}

- (SBCellCoordinate)coordinateForFreeCell
{
    return [self coordinateForShot];
}

@end
