//
//  SBAIEasyPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/11/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIEasyPlayer.h"
#import "NSArrayExtensions.h"

@implementation SBAIEasyPlayer

- (SBCellCoordinate)coordinateForShot
{
    NSArray *avaiableCells = [self.userCells allCellsWithMask:SBGameFieldCellStateFree];
    SBGameFieldCell *randomCell = [avaiableCells objectAtIndex:arc4random() % avaiableCells.count];
    return randomCell.coordinate;
}

@end
