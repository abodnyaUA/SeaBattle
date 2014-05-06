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
#import "SBAIPlayer.h"
#import "NSArray+SBGameFieldCell.h"
#import "SBShipLayouter.h"


@interface SBGameViewController ()

@property (nonatomic, weak  ) IBOutlet SBGameFieldView *currentFieldView;
@property (nonatomic, strong) IBOutlet SBShipPositionController *positionController;
@property (nonatomic, weak  ) IBOutlet SBChooseShipsView *chooseShipsView;
@property (weak, nonatomic) IBOutlet UIButton *readyButton;

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
    //TODO: use abstracts
    [[SBGameController sharedController] initializeGameWithPlayer:[SBAIPlayer new]];
    
    
    [self.chooseShipsView load];
    self.positionController = [SBShipPositionController new];
    self.positionController.fieldView = self.currentFieldView;
    self.positionController.ships = [self.chooseShipsView.ships valueForKey:@"ship"];
    self.readyButton.enabled = NO;
}

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForPosition:(SBCellCoordinate)position
{
    return [SBGameController.sharedController.userCells cellWithPosition:position];
}

- (void)gameFieldView:(SBGameFieldView *)gameFieldView didTapOnCellWithPosition:(SBCellCoordinate)position
{
    if ([gameFieldView isEqual:self.currentFieldView])
    {
        SBGameFieldCell *cell = [SBGameController.sharedController.userCells cellWithPosition:position];
        cell.state = SBGameFieldCellStateUnderAtack;
        [gameFieldView setNeedsDisplay];
    }
}

#pragma mark - SBChooseShipsViewDelegate

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDroppedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if ([self.positionController canMoveShipElementView:shipElementView toPosition:coordinate] || [self.positionController canMoveShipElementView:shipElementView toPosition:shipElementView.ship.topLeftPosition])
    {
        [self.positionController moveShipElementView:shipElementView toPosition:coordinate];
    }
    else
    {
        [chooseShipsView resetShipElementView:shipElementView];
    }
    self.readyButton.enabled = [self.positionController allShipsOnField];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didRotateShipElementView:(SBShipElementView *)shipElementView
{
    [self.positionController rotateShipElementView:shipElementView];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDraggedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if (![self.positionController canMoveShipElementView:shipElementView toPosition:coordinate])
    {
        shipElementView.backgroundColor = [UIColor redColor]; //TODO:use better selection
    }
    else
    {
        shipElementView.backgroundColor = [UIColor greenColor];
    }
}

- (IBAction)didTapOnReadyButton:(id)sender
{
    [SBShipLayouter layoutShips:self.positionController.ships onCells:SBGameController.sharedController.userCells];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:SBShipElementView.class])
        {
            [view removeFromSuperview];
        }
    }
    [self.readyButton removeFromSuperview];
    [self.chooseShipsView removeFromSuperview];
    [self.currentFieldView setNeedsDisplay];
}

@end
