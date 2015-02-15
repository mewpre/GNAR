//
//  AddPlayersViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/14/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@protocol AddPlayersDelegate <NSObject>

- (void)addFriendsSaveButtonPressed:(NSMutableArray *)selectedUsersArray;

@end

@interface AddPlayersViewController : UIViewController

@property (nonatomic, weak) id <AddPlayersDelegate> delegate;

@property NSMutableArray *selectedUsersArray;

@end