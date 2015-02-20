//
//  ModifiersListTableViewCell.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifiersListTableViewCell : UITableViewCell
<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property NSMutableArray *modifiersList;
@property NSString *playerText;

- (void)adjustHeightOfTableview;

@end
