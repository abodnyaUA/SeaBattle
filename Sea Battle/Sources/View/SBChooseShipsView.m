//
//  SBChooseShipsView.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBChooseShipsView.h"

#import "SBGameController.h"

@interface SBChooseShipsView ()

@property (nonatomic, strong) NSArray *ships;
@property (nonatomic, strong) NSArray *labelCount;

@end

@implementation SBChooseShipsView

- (void)load
{
    CGFloat cellSize = [[[SBGameController sharedController] gameFieldView] cellSize];
    NSMutableArray *ships = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    for (NSUInteger shipLength = 4; shipLength >= 1; shipLength--)
    {
        NSUInteger maxCount = 4 - shipLength;
        
        BOOL firstColumn = shipLength > 2;
        
        CGFloat labelWidth = 15;
        CGFloat labelOffset = 5;
        CGFloat labelX = firstColumn ? labelOffset : self.bounds.size.width - labelWidth;
        CGFloat labelY = 5 + cellSize * (maxCount % 2);
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, cellSize)];
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)maxCount+1];
        [labels addObject:countLabel];
        [self addSubview:countLabel];
        
        for (NSUInteger shipCount = 0; shipCount <= maxCount; shipCount++)
        {
            CGFloat shipX = firstColumn ? labelOffset + labelWidth : self.bounds.size.width - (labelWidth + labelOffset + shipLength * cellSize);
            CGFloat shipY = 5 + cellSize * (maxCount % 2) + self.frame.origin.y;
            SBShipElementView *shipView = [[SBShipElementView alloc] initWithShipLength:shipLength withCellSize:cellSize inPoint:CGPointMake(shipX, shipY)];
            [self.superview addSubview:shipView];
            shipView.delegate = self;
            shipView.ship.delegate = self;
            [ships addObject:shipView];
        }
    }
    self.ships = [ships copy];
    self.labelCount = [labels copy];
}

- (BOOL)shipElementViewLocatedInChooseView:(SBShipElementView *)shipElementView
{
    CGFloat cellSize = [[[SBGameController sharedController] gameFieldView] cellSize];
    return shipElementView.frame.origin.y + cellSize / 2 <= self.bounds.size.height + self.frame.origin.y;
}

- (void)shipElementViewDidDragged:(SBShipElementView *)shipElementView
{
    if ([self.delegate respondsToSelector:@selector(chooseShipsView:didDraggedShipElementView:)])
    {
        [self.delegate chooseShipsView:self didDraggedShipElementView:shipElementView];
    }
}

- (void)shipElementViewDidDropped:(SBShipElementView *)shipElementView
{
    if ([self shipElementViewLocatedInChooseView:shipElementView])
    {
        [self resetShipElementView:shipElementView];
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseShipsView:didDroppedShipElementView:)])
    {
        [self.delegate chooseShipsView:self didDroppedShipElementView:shipElementView];
    }
    [self updateUnusedShipCountForShipsWithLenth:shipElementView.ship.length];
}

- (void)resetShipElementView:(SBShipElementView *)shipElementView
{
    if (shipElementView.ship.orientation == SBShipOrientationVertical)
    {
        [shipElementView rotate];
    }
    shipElementView.frame = CGRectMake(shipElementView.defaultPoint.x, shipElementView.defaultPoint.y, shipElementView.frame.size.width, shipElementView.frame.size.height);
    shipElementView.ship.topLeftPosition = SBCellCoordinateZero;
}

- (void)updateUnusedShipCountForShipsWithLenth:(NSUInteger)shipLength
{
    NSInteger count = [self.ships filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SBShipElementView *view, NSDictionary *bindings)
    {
        return view.frame.origin.x == view.defaultPoint.x && view.frame.origin.y == view.defaultPoint.y && view.ship.length == shipLength;
    }]].count;
    UILabel *labelCountLabel = (UILabel *)[self.labelCount objectAtIndex:(4 -shipLength)];
    [labelCountLabel setText:[NSString stringWithFormat:@"%ld",(long)count]];
    
}

- (void)shipElementViewDidTapped:(SBShipElementView *)shipElementView
{
    if (![self shipElementViewLocatedInChooseView:shipElementView])
    {
        if ([self.delegate respondsToSelector:@selector(chooseShipsView:didRotateShipElementView:)])
        {
            [self.delegate chooseShipsView:self didRotateShipElementView:shipElementView];
        }
    }
}

#pragma mark - SBShipElementDelegate

- (SBShipElementView *)shipElementViewWithShip:(SBShipElement *)ship
{
    SBShipElementView *shipView = [self.ships objectAtIndex:[self.ships indexOfObjectPassingTest:^BOOL(SBShipElementView *shipView, NSUInteger idx, BOOL *stop)
    {
        return *stop = (shipView.ship == ship);
    }]];
    return shipView;
}

- (void)shipDidMoved:(SBShipElement *)ship
{
    SBCellCoordinate position = ship.topLeftPosition;
    SBShipElementView *shipElementView = [self shipElementViewWithShip:ship];
    SBGameFieldView *gameFieldView = [[SBGameController sharedController] gameFieldView];
    CGFloat cellSize = [gameFieldView cellSize];
    CGFloat x = position.x * cellSize + gameFieldView.frame.origin.x;
    CGFloat y = position.y * cellSize + gameFieldView.frame.origin.y;
    shipElementView.frame = CGRectMake(x, y, shipElementView.frame.size.width, shipElementView.frame.size.height);
    shipElementView.backgroundColor = [UIColor clearColor]; // TODO: Better higlight
}

- (void)shipDidRotated:(SBShipElement *)ship
{
    SBShipElementView *shipElementView = [self shipElementViewWithShip:ship];
    [shipElementView rotate];
}

@end
