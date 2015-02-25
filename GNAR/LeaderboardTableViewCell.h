//
//  LeaderboardTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/23/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
//@property (weak, nonatomic) IBOutlet UILabel *scoreRatioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
