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
#import "SBAINormalPlayer.h"
#import "NSArrayExtensions.h"
#import "SBShipLayouter.h"
#import "SBGameEnviroment.h"


@interface SBGameViewController ()

@property (nonatomic, weak  ) IBOutlet SBGameFieldView *currentFieldView;
@property (nonatomic, strong) IBOutlet SBShipPositionController *positionController;
@property (nonatomic, weak  ) IBOutlet SBChooseShipsView *chooseShipsView;
@property (nonatomic, weak  ) IBOutlet UIBarButtonItem *readyButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *previewButton;
@property (nonatomic, weak  ) IBOutlet UIView *gameProgressContainerView;
@property (nonatomic, weak  ) IBOutlet UILabel *gameStatusView;
@property (nonatomic, weak  ) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView *oponentImageView;
@property (nonatomic, weak  ) IBOutlet UIProgressView *userProgressView;
@property (nonatomic, weak  ) IBOutlet UIProgressView *oponentProgressView;

@property (nonatomic, assign) BOOL isPreviewActive;

@end

@implementation SBGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [SBGameController.sharedController removeObserver:self forKeyPath:@"gameState"];
}

- (void)initialize
{
    [[SBGameController sharedController] setGameFieldView:self.currentFieldView];
    //TODO: use abstracts
    id<SBPlayer> player = [SBAINormalPlayer new];
    player.delegate = self;
    [SBGameController.sharedController initializeGameWithPlayer:player];
    [SBGameController.sharedController addObserver:self forKeyPath:@"gameState" options:NSKeyValueObservingOptionNew context:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(gameDidFinished:) name:kSBGameDidFinishedNotification object:nil];
    
    
    [self.chooseShipsView load];
    self.positionController = [SBShipPositionController new];
    self.positionController.fieldView = self.currentFieldView;
    self.positionController.ships = [self.chooseShipsView.ships valueForKey:@"ship"];
    self.readyButton.enabled = NO;
    
    self.userImageView.image = SBGameEnviroment.sharedEnviroment.playerInfo.avatar;
    self.oponentImageView.image = player.info.avatar;
    self.isPreviewActive = NO;
}

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForPosition:(SBCellCoordinate)position
{
    SBGameFieldCell *cell = nil;
    if (SBGameController.sharedController.gameStarted && !self.isPreviewActive)
    {
        cell = [SBGameController.sharedController.enemyCells cellWithPosition:position];
    }
    else
    {
        cell = [SBGameController.sharedController.userCells cellWithPosition:position];
    }
    return cell;
}

- (void)gameFieldView:(SBGameFieldView *)gameFieldView didTapOnCellWithPosition:(SBCellCoordinate)position
{
    SBGameController *gameController = SBGameController.sharedController;
    if (gameController.activePlayer == SBActivePlayerUser && gameController.gameStarted && [gameController.enemyCells cellWithPosition:position].state == SBGameFieldCellStateFree && !self.isPreviewActive)
    {
        [self shotEnemyPlayerInCellWithPosition:position];
    }
}

#pragma mark - SBChooseShipsViewDelegate

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDroppedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if ([self.positionController canMoveShip:shipElementView.ship toPosition:coordinate] || [self.positionController canMoveShip:shipElementView.ship toPosition:shipElementView.ship.topLeftPosition])
    {
        [self.positionController moveShipElement:shipElementView.ship toPosition:coordinate];
    }
    else
    {
        [chooseShipsView resetShipElementView:shipElementView];
    }
    self.readyButton.enabled = [self.positionController allShipsOnField];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didRotateShipElementView:(SBShipElementView *)shipElementView
{
    [self.positionController rotateShipElement:shipElementView.ship];
}

- (void)chooseShipsView:(SBChooseShipsView *)chooseShipsView didDraggedShipElementView:(SBShipElementView *)shipElementView
{
    SBCellCoordinate coordinate = SBCellCoordinateOfShipElementView(shipElementView);
    if (![self.positionController canMoveShip:shipElementView.ship toPosition:coordinate])
    {
        shipElementView.backgroundColor = [UIColor redColor]; //TODO:use better selection
    }
    else
    {
        shipElementView.backgroundColor = [UIColor greenColor];
    }
}

#pragma mark - Player Delegate

- (void)playerDidSetupShips:(id<SBPlayer>)player
{
    SBGameController.sharedController.gameState |= SBGameStateReadyOponent;
}

- (void)player:(id<SBPlayer>)player didShotToCellWithPosition:(SBCellCoordinate)position withResultBlock:(SBShotResultBlock)block
{
    NSString *enemyPlayerName = SBGameController.sharedController.enemyPlayer.info.name;
    SBGameController *gameController = [SBGameController sharedController];
    SBGameFieldCell *cell = [gameController.userCells cellWithPosition:position];
    [gameController.userCells shotToCellWithPosition:position];
    [self.currentFieldView setNeedsDisplay];
    
    // Enemy missed: cell.state == SBGameFieldCellStateUnavailable
    self.currentPlayer = cell.state == SBGameFieldCellStateUnavailable ? SBActivePlayerUser : SBActivePlayerOpponent;
    
    NSLog(@"Enemy player did shot %@", cell.state == SBGameFieldCellStateUnavailable ? @"failured" : @"success");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentFieldView setNeedsDisplay];
    });
    
    block(cell.state);
    
    switch (cell.state)
    {
        case SBGameFieldCellStateUnavailable:
            self.gameStatusView.text = [NSString stringWithFormat:@"%@ is stupid mokey :p",enemyPlayerName];
            break;
        case SBGameFieldCellStateUnderAtack:
            self.gameStatusView.text = @"Your ships are under attack!";
            break;
        case SBGameFieldCellStateDefended:
            self.gameStatusView.text = [NSString stringWithFormat:@"%@ killed your ship :(",enemyPlayerName];
            break;
            
        default: break;
    }
    [self recalcProgressView:self.userProgressView withCells:gameController.userCells];
    
    [gameController.userCells printShips];
    [[SBGameController sharedController] checkGameEnd];
}

- (void)shotEnemyPlayerInCellWithPosition:(SBCellCoordinate)position
{
    NSString *enemyPlayerName = SBGameController.sharedController.enemyPlayer.info.name;
    SBGameController *gameController = SBGameController.sharedController;
    self.currentPlayer = SBActivePlayerOpponent; // Block shoting
    [gameController.enemyPlayer shotToCellAtPosition:position withResultBlock:^(SBGameFieldCellState state)
     {
         [gameController.enemyCells cellWithPosition:position].state = state;
         if (state == SBGameFieldCellStateDefended)
         {
             [gameController.enemyCells defendShipWithCoordinate:position];
         }
         
         if (state == SBGameFieldCellStateUnavailable)
         {
             self.gameStatusView.text = [NSString stringWithFormat:@"%@ is thinking",enemyPlayerName];
             self.currentPlayer = SBActivePlayerOpponent;
         }
         else
         {
             self.gameStatusView.text = @"Nice job!";
             self.currentPlayer = SBActivePlayerUser;
         }
         
         [self.currentFieldView setNeedsDisplay];
         
         [self recalcProgressView:self.oponentProgressView withCells:gameController.enemyCells];
         
         NSLog(@"User did shot %@", state == SBGameFieldCellStateUnavailable ? @"failured" : @"success");
         [[SBGameController sharedController] checkGameEnd];
     }];
}

- (void)recalcProgressView:(UIProgressView *)progressView withCells:(NSArray *)cells
{
    NSUInteger maxCells = [[SBGameEnviroment sharedEnviroment] maxCells];
    NSUInteger defended = [cells allCellsWithMask:SBGameFieldCellStateDefended | SBGameFieldCellStateUnderAtack].count;
    progressView.progress = (float)(maxCells - defended) / (float)maxCells;
}
- (IBAction)didTapOnPreviewButton:(id)sender
{
    self.isPreviewActive = !self.isPreviewActive;
    [self.currentFieldView setNeedsDisplay];
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
    [self.chooseShipsView removeFromSuperview];
    [self.gameProgressContainerView setHidden:NO];
    SBGameController.sharedController.gameState |= SBGameStateReadyUser;
    if (SBGameController.sharedController.gameState != SBGameStateReady)
    {
        self.gameStatusView.text = @"Wait for other player";
    }
    self.navigationItem.rightBarButtonItem = self.previewButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"gameState"])
    {
        if (SBGameController.sharedController.gameState == SBGameStateReady)
        {
            self.currentPlayer = SBActivePlayerUser;
            self.gameStatusView.text = @"Start destroying!";
            [self.currentFieldView setNeedsDisplay];
        }
    }
}

- (void)setCurrentPlayer:(SBActivePlayer)activePlayer
{
    [SBGameController.sharedController setActivePlayer:activePlayer];
}

- (void)gameDidFinished:(NSNotification *)notification
{
    SBGameFinishingReason reason = [[notification.userInfo objectForKey:@"reason"] unsignedIntegerValue];
    NSString *alertText;
    switch (reason)
    {
        case SBGameFinishingReasonUserWins:
            alertText = @"You win! Congratulations!";
            break;
        case SBGameFinishingReasonOponentWins:
            alertText = @"You loose... May be in next time?";
            break;
        case SBGameFinishingReasonUserLeave:
            alertText = @"You've leaved game? OMG!";
            break;
        case SBGameFinishingReasonOponentLeave:
            alertText = @"Your oponent did leave game! Haha!";
            break;
            
        default:
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Finished" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
