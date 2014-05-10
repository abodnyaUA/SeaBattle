//
//  UIColor+SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "UIColorExtensions.h"

@implementation UIColor (SBGameFieldCell)

+ (UIColor *)colorForCellState:(SBGameFieldCellState)state
{
    UIColor *result = nil;
    switch (state)
    {
        case SBGameFieldCellStateFree: result = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateUnavailable: result = [UIColor colorWithRed:176.0/255.0 green:196.0/255.0 blue:222.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateDefended: result = [UIColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateUnderAtack: result = [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateWithShip: result = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1.0]; break;
    }
    return result;
}

@end
