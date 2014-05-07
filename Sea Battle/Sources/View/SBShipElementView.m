//
//  SBShipElementView.m
//  Sea Battle
//
//  Created by Aleksey Bodnya on 25.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import "SBShipElementView.h"

#import "SBGameFieldCellView.h"
#import "SBGameFieldCell.h"

@interface SBShipElementView ()

@property (nonatomic, assign) CGFloat cellSize;
@property (nonatomic, assign) BOOL didMoved;

@end

@implementation SBShipElementView

- (id)initWithShipLength:(NSUInteger)length withCellSize:(CGFloat)cellSize inPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, cellSize * length, cellSize)];
    self.defaultPoint = point;
    if (nil != self)
    {
        self.ship = [SBShipElement shipWithLength:length];
        self.cellSize = cellSize;
        self.backgroundColor = [UIColor clearColor];
        self.didMoved = NO;
        self.ship.topLeftPosition = SBCellCoordinateZero;
        self.ship.topLeftPosition = SBCellCoordinateZero;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.2;
    
    if ([self.delegate respondsToSelector:@selector(shipElementViewDidDragged:)])
    {
        [self.delegate shipElementViewDidDragged:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.didMoved = YES;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint previousPosition = [touch previousLocationInView:self];
    
    self.center = CGPointMake(self.center.x + touchPoint.x - previousPosition.x,
                              self.center.y + touchPoint.y - previousPosition.y);
    if ([self.delegate respondsToSelector:@selector(shipElementViewDidDragged:)])
    {
        [self.delegate shipElementViewDidDragged:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
    
    if (self.didMoved)
    {
        if ([self.delegate respondsToSelector:@selector(shipElementViewDidDropped:)])
        {
            [self.delegate shipElementViewDidDropped:self];
        }
        self.didMoved = NO;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(shipElementViewDidTapped:)])
        {
            [self.delegate shipElementViewDidTapped:self];
        }
    }
    self.backgroundColor = [UIColor clearColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)rotate
{
    self.ship.orientation = 1 - self.ship.orientation; // Change orientation;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.height, self.frame.size.width);
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSUInteger i=0; i<self.ship.length; i++)
    {
        CGRect cellRect;
        if (self.ship.orientation == SBShipOrientationHorizontal)
        {
            cellRect = CGRectMake(self.cellSize * i + self.cellSize/12, self.cellSize/12, self.cellSize - self.cellSize/6, self.cellSize - self.cellSize/6);
        }
        else
        {
            cellRect = CGRectMake(self.cellSize/12, self.cellSize * i + self.cellSize/12, self.cellSize - self.cellSize/6, self.cellSize - self.cellSize/6);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextFillRect(context, cellRect);
    }
}

@end
