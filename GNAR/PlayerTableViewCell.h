//
//  PlayerTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerTableViewCellDelegate <NSObject>

- (void)didPressAddPlayersButton;

@end

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) id <PlayerTableViewCellDelegate> delegate;

@end
