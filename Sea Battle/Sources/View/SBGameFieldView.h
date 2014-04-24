//
//  SBGameFieldView.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBGameFieldCell;
@protocol SBGameFieldViewDataSource;

@interface SBGameFieldView : UIView

@property (nonatomic, weak) IBOutlet id<SBGameFieldViewDataSource> dataSource;

@end

@protocol SBGameFieldViewDataSource <NSObject>

@required

- (SBGameFieldCell *)gameFieldView:(SBGameFieldView *)gameFieldView cellForIndexPath:(NSIndexPath *)indexPath;

@end
