//
//  SnowTableViewCell.m
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "SnowTableViewCell.h"

@implementation SnowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onSegmentSelected:(UISegmentedControl *)sender
{
//    NSLog(@"Changed selection!!");
    [self.delegate didChangeSegment:sender.selectedSegmentIndex];
}

@end
