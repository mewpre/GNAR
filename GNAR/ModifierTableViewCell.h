//
//  ModifierTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifierTableViewCellDelegate <NSObject>

- (void)didPressAddModifiersButton;

@end

@interface ModifierTableViewCell : UITableViewCell

@property (weak, nonatomic) id <ModifierTableViewCellDelegate> delegate;

@end
