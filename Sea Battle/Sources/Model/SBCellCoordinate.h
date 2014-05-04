//
//  SBCellCoordinate.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBShipElementView;

struct SBCellCoordinate {
    NSUInteger x;
    NSUInteger y;
};

typedef struct SBCellCoordinate SBCellCoordinate;

#define SBCellCoordinateZero SBCellCoordinateMake(NSNotFound,NSNotFound)
SBCellCoordinate SBCellCoordinateMake(NSUInteger x, NSUInteger y);
SBCellCoordinate SBCellCoordinateOfShipElementView(SBShipElementView *shipElementView);
BOOL SBCellCoordinateEquals(SBCellCoordinate coordinate1, SBCellCoordinate coordinate2);
BOOL SBCellCoordinateIsValid(SBCellCoordinate coordinate);

NSValue *SBCellCoordinateEncoded(SBCellCoordinate coordinate);
SBCellCoordinate SBCellCoordinateDecoded(NSValue *value);
