//
//  SBGameFieldView.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBGameFieldView.h"

#include "SBGameFieldCell.h"

@interface SBGameFieldView ()

//@property (nonatomic, strong) NSArray *cells;

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
    
}

- (CGFloat)cellSize
{
    return MIN((self.bounds.size.height / 10.0),(self.bounds.size.width / 10.0));
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (int i=0; i<10; i++)
    {
        for (int j=0;j<10;j++)
        {
            SBGameFieldCell *cell = [self.dataSource gameFieldView:self cellForIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            CGFloat cellSize = self.cellSize;
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellSize * j + cellSize/12, cellSize * i + cellSize/12, cellSize - cellSize/6, cellSize - cellSize/6)];
            cellView.backgroundColor = cell.color;
            [self addSubview:cellView];
        }
    }
}

@end
