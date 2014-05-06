//
//  SBAIPlayer.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 5/6/14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBAIPlayer.h"

#import "SBAIAutomaticShipLayouter.h"


@interface SBAIPlayer ()

@property (nonatomic, strong) SBAIAutomaticShipLayouter *shipLayouter;

@end

@implementation SBAIPlayer

- (instancetype)init
{
    self = [super init];
    if (nil != self)
    {
        self.shipLayouter = [SBAIAutomaticShipLayouter new];
    }
    return self;
}

- (void)shotToCellAtPosition:(SBCellCoordinate)position withResultBlock:(void (^)(SBGameFieldCellState))block
{
    
}

@end
