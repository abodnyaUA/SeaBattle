//
//  UIImageExtensions.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/18/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBImageExtensions.h"

@implementation SBImage (SBGameFieldCell)

+ (SBImage *)iconForCellState:(SBGameFieldCellState)state
{
    NSString *imageName = nil;
    switch (state)
    {
        case SBGameFieldCellStateFree: imageName = nil; break;
        case SBGameFieldCellStateUnavailable: imageName = @"missed.png"; break;
        case SBGameFieldCellStateDefended: imageName = @"ship_defended.png"; break;
        case SBGameFieldCellStateUnderAtack: imageName = @"ship_defended.png"; break;
        case SBGameFieldCellStateWithShip: imageName = @"ship.png"; break;
    }
    return nil != imageName ? [SBImage imageNamed:imageName] : nil;
}

@end
