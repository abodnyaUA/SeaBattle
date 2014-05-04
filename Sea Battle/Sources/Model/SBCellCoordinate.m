//
//  SBCellCoordinate.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBCellCoordinate.h"

#import "SBGameController.h"
#import "SBShipElementView.h"

SBCellCoordinate SBCellCoordinateMake(NSUInteger x, NSUInteger y)
{
    SBCellCoordinate coordinate;
    coordinate.x = x;
    coordinate.y = y;
    return coordinate;
}

SBCellCoordinate SBCellCoordinateOfShipElementView(SBShipElementView *shipElementView)
{
    CGFloat cellSize = [[SBGameController sharedController] cellSize];
    CGRect fieldFrame = [[[SBGameController sharedController] gameFieldView] frame];
    
    CGFloat x = (shipElementView.frame.origin.x + cellSize/2);
    CGFloat y = (shipElementView.frame.origin.y + cellSize/2 - fieldFrame.origin.y);
    
    
    x = (NSUInteger)x / cellSize;
    y = (NSUInteger)y / cellSize;
    
    SBCellCoordinate coordinate = SBCellCoordinateMake(x, y);
    return coordinate;
}

BOOL SBCellCoordinateEquals(SBCellCoordinate coordinate1, SBCellCoordinate coordinate2)
{
    return coordinate1.x == coordinate2.x && coordinate1.y == coordinate2.y && SBCellCoordinateIsValid(coordinate1) && SBCellCoordinateIsValid(coordinate2);
}

BOOL SBCellCoordinateIsValid(SBCellCoordinate coordinate)
{
    return coordinate.x < 10 && coordinate.y < 10;
}

NSValue *SBCellCoordinateEncoded(SBCellCoordinate coordinate)
{
    return [NSValue value:&coordinate withObjCType:@encode(SBCellCoordinate)];
}

SBCellCoordinate SBCellCoordinateDecoded(NSValue *value)
{
    SBCellCoordinate coordinate;
    [value getValue:&coordinate];
    return coordinate;
}
