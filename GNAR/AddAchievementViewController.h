//
//  AddAchievementTableViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoTableViewCell.h"
#import "SnowTableViewCell.h"
#import "ModifierTableViewCell.h"
#import "PlayerTableViewCell.h"
#import "Achievement.h"

@interface AddAchievementViewController : UIViewController

@property NSMutableArray *playersArray;
@property NSMutableArray *modifiersArray;
@property Achievement *achievement;

@end
