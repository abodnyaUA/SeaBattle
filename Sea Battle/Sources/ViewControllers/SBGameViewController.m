//
//  SBViewController.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameViewController.h"

#import "SBGameFieldCell.h"
#import "SBShipPositionController.h"
#import "SBGameController.h"
#import "NSArray+SBGameFieldCell.h"


@interface SBGameViewController ()

@property (nonatomic, weak  ) IBOutlet SBGameFieldView *enemyFieldView;
@property (nonatomic, weak  ) IBOutlet SBGameFieldView *userFieldView;
@property (nonatomic, weak  ) IBOutlet SBGameFieldView *currentFieldView;

@end

@implementation SBGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)initialize
{
    [[SBGameController sharedController] setGameFieldView:self.currentFieldView];
    [[SBGameController sharedController] initializeGame];
}

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForPosition:(SBCellCoordinate)position
{
    if ([gameFieldView isEqual:self.userFieldView] || [gameFieldView isEqual:self.currentFieldView])
    {
        return [SBGameController.sharedController.userCells cellWithPosition:position];
    }
    else
    {
        return [SBGameController.sharedController.enemyCells cellWithPosition:position];
    }
}

- (void)gameFieldView:(SBGameFieldView *)gameFieldView didTapOnCellWithPosition:(SBCellCoordinate)position
{
    if ([gameFieldView isEqual:self.currentFieldView])
    {
        SBGameFieldCell *cell = [[SBGameController.sharedController.userCells objectAtIndex:position.y] objectAtIndex:position.x];
        cell.state = SBGameFieldCellStateUnderAtack;
        [gameFieldView setNeedsDisplay];
    }
}

#pragma mark - SBChooseShipsViewDelegate

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDroppedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    [SBGameController.sharedController.positionController moveShipElementView:shipElementView toPosition:coordinate];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didRotateShipElementView:(SBShipElementView *)shipElementView
{
    [SBGameController.sharedController.positionController rotateShipElementView:shipElementView];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDraggedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if (![SBGameController.sharedController.positionController canMoveShipElementView:shipElementView toPosition:coordinate])
    {
        shipElementView.backgroundColor = [UIColor redColor]; //TODO:use better selection
    }
    else
    {
        shipElementView.backgroundColor = [UIColor greenColor];
        shipElementView.ship.lastAvailablePosition = coordinate;
    }
}

@end
