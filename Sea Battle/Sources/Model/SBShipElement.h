//
//  SBShipElement.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBCellCoordinate.h"

typedef NS_ENUM(NSUInteger, SBShipOrientation)
{
    SBShipOrientationHorizontal = 0,
    SBShipOrientationVertical
};

@interface SBShipElement : NSObject

@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) SBShipOrientation orientation;
@property (nonatomic, assign) SBCellCoordinate topLeftPosition;

+ (instancetype)shipWithLength:(NSUInteger)length;

@end
