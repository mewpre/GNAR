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
#import "ModifiersListTableViewCell.h"
#import "PlayerTableViewCell.h"
#import "Achievement.h"

@protocol AchievementDetailTableViewDelegate <NSObject>

- (void)didRemovePlayerOnSwipe;

@end

@interface AchievementDetailTableView : SubTableView // Actually a cell that contains a table view
<UITableViewDataSource, UITableViewDelegate, SnowTableViewCellDelegate, InfoTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *insideTableView;
@property Achievement *achievement;
@property NSArray *achievementsArray;
@property NSMutableDictionary *modifiersDictionary;
@property NSMutableArray *playersArray;
@property NSMutableString *snowIndexString;
@property NSMutableString *saveKey;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property NSMutableString *heightString;

@property (weak, nonatomic) id<AchievementDetailTableViewDelegate> detailDelegate;


@end
