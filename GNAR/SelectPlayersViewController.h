//
//  AddPlayersViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/14/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@protocol SelectPlayersViewControllerDelegate <NSObject>

//TODO: remove selectedUserArray from this method (we don't need it anymore) and refactor
- (void)didPressDoneButtonWithSelectedUsers:(NSMutableArray *)selectedUsersArray;

@end

@interface SelectPlayersViewController : UIViewController

@property (nonatomic, weak) id <SelectPlayersViewControllerDelegate> delegate;

@property NSMutableArray *selectedUsersArray;

@end