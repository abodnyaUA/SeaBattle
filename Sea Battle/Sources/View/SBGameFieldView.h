//
//  SBGameFieldView.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBCellCoordinate.h"

@class SBGameFieldCell;
@protocol SBGameFieldViewDataSource;
@protocol SBGameFieldViewDelegate;

@interface SBGameFieldView : UIView

@property (nonatomic, weak) IBOutlet id<SBGameFieldViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<SBGameFieldViewDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat cellSize;

@end

@protocol SBGameFieldViewDataSource <NSObject>

@required

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForPosition:(SBCellCoordinate)position;
- (UIColor *)gameFieldViewBackgroundColor:(SBGameFieldView *)gameFieldView;

@end

@protocol SBGameFieldViewDelegate <NSObject>

@optional

- (void)gameFieldView:(SBGameFieldView *)gameFieldView didTapOnCellWithPosition:(SBCellCoordinate)position;

@end