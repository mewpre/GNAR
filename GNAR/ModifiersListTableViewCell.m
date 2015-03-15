//
//  ModifiersListTableViewCell.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "ModifiersListTableViewCell.h"
#import "Achievement.h"
#import "Score.h"

@implementation ModifiersListTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.textLabel.text = self.playerText;
        cell.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0];

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ModifierCell"];
        Score *score = [self.modifiersList objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", score.achievementPointer.abbreviation, score.achievementPointer.name];
        cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", score.score];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // First section is user
    if (section == 0)
    {
        return 1;
    }
    else
    {
//        NSLog(@"Number of modifiers: %lu", (unsigned long)self.modifiersList.count);
        return self.modifiersList.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Add logic where if parent cell is removed, all cells are removed.
    if (indexPath.section == 0)
    {
        // Call delegate in AchievementDetailVC to delete player from "users" array and remove key "selectedPLayer" from modifiersDictionary (using delegation!)
        [self.delegate didRemovePlayerCell:self];
    }
    else
    {
        [self.modifiersList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.tableView reloadData];
    [self adjustHeightOfTableview];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)adjustHeightOfTableview
{
    //TODO: make delegate method to adjust table height of both ModifierListTableView and AchievementDetailTableView
    CGFloat height = self.tableView.contentSize.height;

    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstraint.constant = height;
        [self layoutIfNeeded];
    }];

//    NSLog(@"Modifiers height: %f", height);
}


@end
