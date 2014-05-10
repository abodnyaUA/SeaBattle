//
//  SBAINormalPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/10/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAINormalPlayer.h"

@implementation SBAINormalPlayer

- (SBCellCoordinate)coordinateForShot
{
    return SBCellCoordinateMake(arc4random() % 10, arc4random() % 10);
}

@end
