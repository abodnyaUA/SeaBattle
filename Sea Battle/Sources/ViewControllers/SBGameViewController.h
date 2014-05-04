//
//  SBViewController.h
//  Sea Battle
//
//  Created by Aleksey Bodnya on 24.04.14.
//  Copyright (c) 2014 Alexey Bodnya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBGameFieldView.h"
#import "SBChooseShipsView.h"

@interface SBGameViewController : UIViewController <SBGameFieldViewDataSource, SBGameFieldViewDelegate,SBChooseShipsViewDelegate>

@end
