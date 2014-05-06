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
    for (NSUInteger shipLength=4; shipLength >= 1; shipLength--)
    {
        NSUInteger maxCount = 4 - shipLength;
        CGFloat y = 5 + cellSize * maxCount;
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 15, cellSize)];
        countLabel.text = [NSString stringWithFormat:@"%ld",(long)maxCount+1];
        [labels addObject:countLabel];
        [self addSubview:countLabel];
        
        y += self.frame.origin.y;
        for (NSUInteger shipCount=0; shipCount <= maxCount; shipCount++)
        {
            SBShipElementView *shipView = [[SBShipElementView alloc] initWithShipLength:shipLength withCellSize:cellSize inPoint:CGPointMake(15 + 5, y)];
            [self.superview addSubview:shipView];
            shipView.delegate = self;
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
    NSInteger count = [self.ships filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SBShipElementView *view, NSDictionary *bindings) {
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
