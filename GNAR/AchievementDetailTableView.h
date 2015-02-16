//
//  AchievementDetailTableView.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "SubTableView.h"

@interface AchievementDetailTableView : SubTableView // Actually a cell that contains a table view
<UITableViewDataSource, UITableViewDelegate, SubTableViewCellDelegate

<UITableViewDataSource, UITableViewDelegate, InfoTableViewCellDelegate, SnowTableViewCellDelegate, ModifierTableViewCellDelegate, PlayerTableViewCellDelegate, SelectPlayersViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UITableView *insideTableView;











@end
