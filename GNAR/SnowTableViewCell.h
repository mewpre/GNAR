//
//  SnowTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SnowTableViewCellDelegate <NSObject>

- (void)didChangeSegment: (NSInteger) selectedSegment;

@end

@interface SnowTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lowSnowScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *medSnowScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highSnowScoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id <SnowTableViewCellDelegate> delegate;

@end
