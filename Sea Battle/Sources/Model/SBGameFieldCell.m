//
//  SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldCell.h"

@implementation SBGameFieldCell

+ (instancetype)cellWithState:(SBGameFieldCellState)state
{
    SBGameFieldCell *cell = [SBGameFieldCell new];
    cell.state = state;
    return cell;
}

//TODO: change for pictures
- (UIColor *)color
{
    UIColor *result = nil;
    switch (self.state)
    {
        case SBGameFieldCellStateFree: result = [UIColor lightGrayColor]; break;
        case SBGameFieldCellStateUnavailable: result = [UIColor darkGrayColor]; break;
        case SBGameFieldCellStateDefended: result = [UIColor redColor]; break;
        case SBGameFieldCellStateWithShip: result = [UIColor blueColor]; break;
        case SBGameFieldCellStateUnderAtack: result = [UIColor yellowColor]; break;
    }
    return result;
}

@end
