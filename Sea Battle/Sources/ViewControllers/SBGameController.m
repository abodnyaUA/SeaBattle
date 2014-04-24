//
//  SBViewController.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameController.h"

#include "SBGameFieldCell.h"

@interface SBGameController ()

@property (nonatomic, strong) NSArray *userCells;
@property (nonatomic, strong) NSArray *enemyCells;
@property (weak, nonatomic) IBOutlet SBGameFieldView *enemyFieldView;
@property (weak, nonatomic) IBOutlet SBGameFieldView *userFieldView;
@property (weak, nonatomic) IBOutlet SBGameFieldView *currentFieldView;

@end

@implementation SBGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)initialize
{
    NSMutableArray *cells = [NSMutableArray array];
    for (int i=0; i<10; i++)
    {
        NSMutableArray *cellsInRow = [NSMutableArray array];
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [SBGameFieldCell cellForRowWithIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            [cellsInRow addObject:cell];
        }
        [cells addObject:cellsInRow];
    }
    self.userCells = [cells copy];
    self.enemyCells = [cells copy];
}

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForIndexPath:(NSIndexPath *)indexPath
{
    if ([gameFieldView isEqual:self.userFieldView] || [gameFieldView isEqual:self.currentFieldView])
    {
        return [[self.userCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        return [[self.enemyCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

@end
