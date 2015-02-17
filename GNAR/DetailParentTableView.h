//
//  DetailParentTableView.h
//  GNAR
//
//  Created by Chris Giersch on 2/15/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "ParentTableView.h"
#import "AchievementDetailTableView.h"

@protocol DetailParentTableViewDelegate <NSObject>

- (void)didGetIndex: (NSInteger)index;

@end

@interface DetailParentTableView : ParentTableView
<UITableViewDataSource, UITableViewDelegate, SubTableViewCellDelegate, AchievementDetailTableViewDelegate>

@property NSArray *achievementsArray;
@property NSMutableString *childHeightString;
@property (weak, nonatomic) id<DetailParentTableViewDelegate> parentDelegate;

@end
