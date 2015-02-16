//
//  AchievementDetailTableView.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "SubTableView.h"
#import "InfoTableViewCell.h"
#import "SnowTableViewCell.h"
#import "ModifierTableViewCell.h"
#import "PlayerTableViewCell.h"
#import "Achievement.h"

@protocol  AchievementDetailTableViewDelegate <NSObject>

- (void)didPressSelectPlayersButton: (NSMutableArray *)playersArray;

@end

@interface AchievementDetailTableView : SubTableView // Actually a cell that contains a table view
<UITableViewDataSource, UITableViewDelegate, InfoTableViewCellDelegate, SnowTableViewCellDelegate, ModifierTableViewCellDelegate, PlayerTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *insideTableView;
@property Achievement *achievement;
@property NSArray *achievementsArray;
@property NSMutableArray *modifiersArray;
@property NSMutableArray *playersArray;

@property (weak, nonatomic) id<AchievementDetailTableViewDelegate> achievementDelegate;











@end
