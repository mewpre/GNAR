//
//  InfoTableViewCell.m
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)addButtonPressed:(UIButton *)sender
{
    NSLog(@"Add Button pressed!!!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
