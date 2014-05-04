//
//  NSArray+SBGameFieldCell.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/2/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "NSArray+SBGameFieldCell.h"

@implementation NSArray (SBGameFieldCell)

- (SBGameFieldCell *)cellWithPosition:(SBCellCoordinate)position
{
    return [[self objectAtIndex:position.y] objectAtIndex:position.x];
}

@end
