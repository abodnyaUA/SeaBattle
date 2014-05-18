//
//  SBViewController.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "SBGameFieldCell.h"
#import "SBShipPositionController.h"
#import "SBGameController.h"
#import "SBAIPlayer.h"
#import "NSArrayExtensions.h"
#import "SBShipLayouter.h"
#import "SBGameEnviroment.h"
#import "SBColorExtensions.h"

static const NSTimeInterval kGameFieldViewFlipAnimationDuration = 0.5;

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

@property (nonatomic, assign) SBActivePlayer visiblePlayer;

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
    SBGameController *gameController = [SBGameController sharedController];
    SBGameEnviroment *gameEnviroment = [SBGameEnviroment sharedEnviroment];
    
    [gameController setGameFieldView:self.currentFieldView];
    //TODO: use abstracts
    id<SBPlayer> player = [[SBAIPlayer alloc] initWithDifficult:SBAIPlayerDifficultHard];
    player.delegate = self;
    [gameController initializeGameWithPlayer:player];
    [gameController addObserver:self forKeyPath:@"gameState" options:NSKeyValueObservingOptionNew context:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(gameDidFinished:) name:kSBGameDidFinishedNotification object:nil];
    self.navigationItem.title = [NSString stringWithFormat:@"Game with %@",SBGameController.sharedController.enemyPlayer.info.name];
    
    
    [self.chooseShipsView load];
    self.positionController = [SBShipPositionController new];
    self.positionController.fieldView = self.currentFieldView;
    self.positionController.ships = [self.chooseShipsView.ships valueForKey:@"ship"];
    self.readyButton.enabled = NO;
    
    self.userImageView.image = gameEnviroment.playerInfo.avatar;
    self.oponentImageView.image = player.info.avatar;
    self.visiblePlayer = SBActivePlayerUser;
}

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForPosition:(SBCellCoordinate)position
{
    SBGameFieldCell *cell = nil;
    if (self.visiblePlayer == SBActivePlayerOpponent)
    {
        cell = [SBGameController.sharedController.enemyCells cellWithPosition:position];
    }
    else
    {
        cell = [SBGameController.sharedController.userCells cellWithPosition:position];
    }
    return cell;
}

- (UIColor *)gameFieldViewBackgroundColor:(SBGameFieldView *)gameFieldView
{
    //TODO customize color
    return self.visiblePlayer == SBActivePlayerUser ? SBGameEnviroment.sharedEnviroment.playerInfo.color : SBGameController.sharedController.enemyPlayer.info.color;
}

- (void)gameFieldView:(SBGameFieldView *)gameFieldView didTapOnCellWithPosition:(SBCellCoordinate)position
{
    SBGameController *gameController = SBGameController.sharedController;
    if (gameController.activePlayer == SBActivePlayerUser && gameController.gameStarted && [gameController.enemyCells cellWithPosition:position].state == SBGameFieldCellStateFree && self.visiblePlayer == SBActivePlayerOpponent)
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
    
    block(cell.state);
    
    switch (cell.state)
    {
        case SBGameFieldCellStateUnavailable:
        {
            self.gameStatusView.textColor = [UIColor blueColor];
            self.gameStatusView.text = [NSString stringWithFormat:@"%@, it's your time",SBGameEnviroment.sharedEnviroment.playerInfo.name];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self switchFieldViews];
            });
            break;
        }
        case SBGameFieldCellStateUnderAtack:
            self.gameStatusView.textColor = [UIColor orangeColor];
            self.gameStatusView.text = @"Your ships are under attack!";
            break;
        case SBGameFieldCellStateDefended:
            self.gameStatusView.textColor = [UIColor redColor];
            self.gameStatusView.text = [NSString stringWithFormat:@"%@ killed your ship :(",enemyPlayerName];
            break;
            
        default: break;
    }
    // Proregress View
    NSUInteger maxCells = [[SBGameEnviroment sharedEnviroment] maxCells];
    NSUInteger defended = [gameController.userCells allCellsWithMask:SBGameFieldCellStateDefended | SBGameFieldCellStateUnderAtack].count;
    self.userProgressView.progress = (float)(maxCells - defended) / (float)maxCells;
    
    [gameController.userCells printShips];
    [[SBGameController sharedController] checkGameEnd];
}

- (void)player:(id<SBPlayer>)player didRespondInformationAboutShipAtPosition:(SBCellCoordinate)position
{
    [SBGameController.sharedController.enemyCells cellWithPosition:position].state = SBGameFieldCellStateWithShip;
    [self.currentFieldView setNeedsDisplay];
}

- (void)switchFieldViews
{
    self.previewButton.enabled = NO;
    
    NSInteger direction = self.visiblePlayer == SBActivePlayerUser ? -1 : 1;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = direction * 0.0015;
    self.currentFieldView.layer.transform = transform;
    
    [self rotateFieldFromDegree:0 toDegree: direction * M_PI_2 withComplitionBlock:^{
        self.currentFieldView.layer.transform = CATransform3DRotate(transform, direction * M_PI_2, 0, direction, 0);
        self.visiblePlayer = 1 - self.visiblePlayer;
        self.navigationItem.title = self.visiblePlayer == SBActivePlayerUser ?
            [NSString stringWithFormat:@"%@'s field",SBGameEnviroment.sharedEnviroment.playerInfo.name] :
            [NSString stringWithFormat:@"Game with %@",SBGameController.sharedController.enemyPlayer.info.name];
        self.previewButton.enabled = YES;
        [self.currentFieldView setNeedsDisplay];
        [self rotateFieldFromDegree:direction * M_PI_2 toDegree:direction * M_PI withComplitionBlock:^{
            self.currentFieldView.layer.transform = CATransform3DRotate(transform, direction * M_PI, 0, direction, 0);
        }];
    }];
    
}

- (void)rotateFieldFromDegree:(CGFloat)degreeStart toDegree:(CGFloat)degreeEnd withComplitionBlock:(dispatch_block_t)block
{
    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:^{
            if (nil != block)
            {
                block();
            }
        }];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        animation.fromValue = @(degreeStart);
        animation.toValue = @(degreeEnd);
        animation.duration = kGameFieldViewFlipAnimationDuration / 2.0;
        [self.currentFieldView.layer addAnimation:animation forKey:animation.keyPath];
    }
    [CATransaction commit];
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
             self.gameStatusView.textColor = [UIColor blackColor];
             self.gameStatusView.text = [NSString stringWithFormat:@"%@ is thinking",enemyPlayerName];
             self.currentPlayer = SBActivePlayerOpponent;
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self switchFieldViews];
             });
         }
         else
         {
             self.gameStatusView.textColor = [UIColor blueColor];
             self.gameStatusView.text = @"Nice job!";
             self.currentPlayer = SBActivePlayerUser;
         }
         
         [self.currentFieldView setNeedsDisplay];
         
         // Proregress View
         NSUInteger maxCells = [[SBGameEnviroment sharedEnviroment] maxCells];
         NSUInteger defended = [gameController.enemyCells allCellsWithMask:SBGameFieldCellStateDefended | SBGameFieldCellStateUnderAtack | SBGameFieldCellStateWithShip].count;
         self.oponentProgressView .progress = (float)(maxCells - defended) / (float)maxCells;
         
         NSLog(@"User did shot %@", state == SBGameFieldCellStateUnavailable ? @"failured" : @"success");
         [[SBGameController sharedController] checkGameEnd];
     }];
}

- (IBAction)didTapOnPreviewButton:(id)sender
{
    [self switchFieldViews];
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
            self.visiblePlayer = SBActivePlayerOpponent;
        }
    }
}

- (void)setCurrentPlayer:(SBActivePlayer)activePlayer
{
    [SBGameController.sharedController setActivePlayer:activePlayer];
}

- (SBActivePlayer)currentPlayer
{
    return SBGameController.sharedController.activePlayer;
}

- (void)gameDidFinished:(NSNotification *)notification
{
    if (!SBGameController.sharedController.gameEnded)
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
        SBGameController.sharedController.gameState = SBGameStateEnded;
    }
}

@end
