//
//  UIColorExtensions.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBColorExtensions.h"

@implementation SBColor (SBGameFieldCell)

+ (SBColor *)colorForCellState:(SBGameFieldCellState)state
{
    SBColor *result = nil;
    switch (state)
    {
        case SBGameFieldCellStateFree: result = [SBColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateUnavailable: result = [SBColor colorWithRed:176.0/255.0 green:196.0/255.0 blue:222.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateDefended: result = [SBColor colorWithRed:255.0/255.0 green:99.0/255.0 blue:71.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateUnderAtack: result = [SBColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0]; break;
        case SBGameFieldCellStateWithShip: result = [SBColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1.0]; break;
    }
    return result;
}

@end

@implementation SBColor (SBNiceColors)

+ (SBColor *)niceBlue
{
    return [SBColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1.0];
}

+ (SBColor *)niceRed
{
    return [SBColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:122.0/255.0 alpha:1.0];
}

+ (SBColor *)niceGreen
{
    return [SBColor colorWithRed:152.0/255.0 green:251.0/255.0 blue:152.0/255.0 alpha:1.0];
}

@end
