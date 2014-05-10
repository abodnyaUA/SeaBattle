//
//  SBGameFieldView.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldView.h"

#import "SBGameFieldCell.h"
#import "SBGameController.h"
#import "SBGameFieldCellView.h"
#import "UIColorExtensions.h"

@interface SBGameFieldView ()

@property (nonatomic, assign) CGFloat cellSize;

@end

@implementation SBGameFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnField:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (CGFloat)cellSize
{
    if (_cellSize == 0)
    {
        self.cellSize = MIN((self.bounds.size.height / 10.0),(self.bounds.size.width / 10.0));
    }
    return _cellSize;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSUInteger i=0; i<10; i++)
    {
        for (NSUInteger j=0; j<10; j++)
        {
            SBCellCoordinate coordinate = SBCellCoordinateMake(j,i);
            SBGameFieldCell *cell = [self.dataSource gameFieldView:self cellForPosition:coordinate];
            
            CGFloat cellSize = [self cellSize];
            CGRect cellRect = CGRectMake(cellSize * j + cellSize/12, cellSize * i + cellSize/12, cellSize - cellSize/6, cellSize - cellSize/6);
            
            CGContextSetFillColorWithColor(context, [UIColor colorForCellState:cell.state].CGColor);
            CGContextFillRect(context, cellRect);
        }
    }
}

- (void)didTapOnField:(UITapGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(gameFieldView:didTapOnCellWithPosition:)])
    {
        CGPoint locationInView = [recognizer locationInView:self];
        CGFloat cellSize = [self cellSize];
        
        SBCellCoordinate coordinate = SBCellCoordinateMake((NSUInteger)(locationInView.x / cellSize), (NSUInteger)(locationInView.y / cellSize));
        
        [self.delegate gameFieldView:self didTapOnCellWithPosition:coordinate];
    }
}

@end
