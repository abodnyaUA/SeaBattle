//
//  SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldCell.h"

@implementation SBGameFieldCell

+ (instancetype)cellForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SBGameFieldCell *cell = [SBGameFieldCell new];
    cell.indexPath = indexPath;
    cell.state = SGGameFieldCellStateFree;
    return cell;
}

- (UIColor *)color
{
    UIColor *result = nil;
    switch (self.state)
    {
        case SGGameFieldCellStateFree: result = [UIColor lightGrayColor]; break;
        case SGGameFieldCellStateUnavailable: result = [UIColor darkGrayColor]; break;
        case SGGameFieldCellStateDefended: result = [UIColor redColor]; break;
        case SGGameFieldCellStateWithShip: result = [UIColor blueColor]; break;
        case SGGameFieldCellStateUnderAtack: result = [UIColor yellowColor]; break;
    }
    return result;
}

@end
