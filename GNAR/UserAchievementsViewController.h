//
//  UserAchievementsViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"
#import "User.h"
#import "Game.h"

@interface UserAchievementsViewController : UIViewController

//@property NSArray *scoresArray;
@property User *currentPlayer;
@property Game *currentGame;

@end
