//
//  SBShipElement.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBShipElement.h"

#import "SBGameFieldCell.h"

@interface SBShipElement ()

@property (nonatomic, strong) NSArray *cells;

@end

@implementation SBShipElement

+ (instancetype)shipWithLength:(NSUInteger)length
{
    NSParameterAssert(length <= 4);
    
    SBShipElement *ship = [SBShipElement new];
    ship.length = length;
    ship.orientation = SBShipOrientationHorizontal;
    return ship;
}

@end
