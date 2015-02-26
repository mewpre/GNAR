//
//  ModifiersListTableViewCell.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifiersListTableViewCellDelegate <NSObject>

- (void)didRemovePlayerCell:(UITableViewCell *)sender;

@end

@interface ModifiersListTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <ModifiersListTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property NSMutableArray *modifiersList;
@property NSString *playerText;

- (void)adjustHeightOfTableview;

@end
