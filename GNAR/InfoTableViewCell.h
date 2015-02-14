//
//  InfoTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *funLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
