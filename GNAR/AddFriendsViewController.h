//
//  AddFriendsViewController.h
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@protocol AddFriendsDelegate <NSObject>

- (void)didPressDoneButtonWithSelectedUsers:(NSArray *)selectedUsersArray;

@end

@interface AddFriendsViewController : UIViewController

@property (nonatomic, weak) id <AddFriendsDelegate> delegate;

@property NSMutableArray *selectedUsersArray;

@end
