//
//  AchievementDetailTableView.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailTableView.h"
#import "User.h"
#import "Enum.h"
@implementation AchievementDetailTableView


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.playersArray = [NSMutableArray new];
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.achievement.type == LineWorth)
    {
        return 4;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.achievement.type == LineWorth)
    {
        if (section == LWModifierCell)
        {
            return self.playersArray.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section == PlayerCell)
        {
            return self.playersArray.count;
        }
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWInfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0]; // darker grey
            infoCell.funLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Fun Factor: %@", self.achievement[@"funFactor"]]];
            infoCell.heroLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hero Factor: %@", self.achievement[@"heroFactor"]]];
            infoCell.difficultyLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Difficulty: %@", self.achievement[@"difficulty"]]];
            infoCell.descriptionTextView.text = [NSString stringWithFormat:@"Description: %@", self.achievement[@"descriptionString"]];  // [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Description: %@", self.achievement[@"descriptionString"]]];
            infoCell.descriptionTextView.backgroundColor = infoCell.backgroundColor;
            infoCell.descriptionTextView.textColor = [UIColor whiteColor];
            infoCell.descriptionTextView.font = [UIFont fontWithName:@"Helvetica Neue" size:17.0];


            return infoCell;
        }
        else if (indexPath.section == LWSnowCell)
        {
            SnowTableViewCell *snowCell = [tableView dequeueReusableCellWithIdentifier:@"SnowCell"];
            snowCell.delegate = self;
            snowCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0]; // lighter grey
            NSMutableArray *pointValues = [NSMutableArray new];
            for (int i = 0; i < self.achievement.pointValues.count; i++)
            {
                NSNumber *score = [self.achievement.pointValues objectAtIndex:i];
                if ([score integerValue] == 0)
                {
                    [pointValues addObject:@"NR"];
                    [snowCell.segmentedControl setEnabled:NO forSegmentAtIndex:i];
                }
                else
                {
                    [pointValues addObject:[NSString stringWithFormat:@"%@", score]];
                    [snowCell.segmentedControl setEnabled:YES forSegmentAtIndex:i];
                }
            }
            snowCell.lowSnowScoreLabel.text = pointValues[0];
            snowCell.medSnowScoreLabel.text = pointValues[1];
            snowCell.highSnowScoreLabel.text = [NSString stringWithFormat:@"%@ pts", pointValues[2]];
            if ([self.snowIndexString integerValue] >= 0)
            {
                snowCell.segmentedControl.selectedSegmentIndex = [self.snowIndexString integerValue];
            }
            else
            {
                snowCell.segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
            }

            return snowCell;
        }
        else if (indexPath.section == LWModifierCell)
        {
            ModifiersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifierCell"];
            User *userAtIndex = self.playersArray[indexPath.row];
            if ([userAtIndex.objectId isEqual:[User currentUser].objectId])
            {
                cell.playerText = [NSString stringWithFormat:@"%@ (me)", userAtIndex.username];
            }
            else
            {
                cell.playerText = userAtIndex.username;
            }
            NSMutableArray *scores = self.modifiersDictionary[userAtIndex.username];
            cell.modifiersList = scores;
            cell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            [cell.tableView reloadData];
            [cell adjustHeightOfTableview];
            return cell;
        }
        else // if (indexPath.section == LWAddModifierCell)
        {
            ModifierTableViewCell *modifierCell = [tableView dequeueReusableCellWithIdentifier:@"AddModifierCell"];
            modifierCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return modifierCell;
        }
    }

    else
    {
        if (indexPath.section == InfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];

            infoCell.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            infoCell.delegate = self;
            // For non-Line Worths, want to display abbreviation and point value instead of fun, difficulty, and hero
            infoCell.funLabel.text = @"";
            infoCell.difficultyLabel.text = @"";
            infoCell.heroLabel.text = [NSString stringWithFormat:@"%@: %@ points", self.achievement[@"abbreviation"], [self.achievement[@"pointValues"] firstObject]];
            infoCell.descriptionTextView.text = [NSString stringWithFormat:@"Description: %@", self.achievement[@"descriptionString"]];
            infoCell.descriptionTextView.backgroundColor = infoCell.backgroundColor;
            infoCell.descriptionTextView.textColor = [UIColor whiteColor];
            return infoCell;
        }
        else if (indexPath.section == PlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0];
            User *userAtIndex = self.playersArray[indexPath.row];
            if ([userAtIndex.objectId isEqual:[User currentUser].objectId])
            {
                playersCell.textLabel.text = [NSString stringWithFormat:@"%@ (me)", userAtIndex.username];

            }
            else
            {
                playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            }
            playersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return playersCell;
        }
        else
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlayersCell"];
            playerCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return playerCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //TODO: Make height dynamic based on height of description text view
        return 220.0;
    }
    else if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWAddModifierCell) // || indexPath.section == LWSelectPlayersCell)
        {
            return 50.0;
        }
        else if (indexPath.section == LWSnowCell)
        {
            return 75.0;
        }
        else if (indexPath.section == LWModifierCell)
        {
            NSString *userName = [self.playersArray[indexPath.row] username];
            NSMutableArray *scores = self.modifiersDictionary[userName];
            // The height of each cell in the ModifiersListTableViewCell table view is 40
            // and the number of rows in that table view is the number of modifiers + 1
            return ((scores.count + 1) * 40);
        }
    }
    else if (indexPath.section == SelectPlayersCell)
    {
        return 50.0;
    }
    return 45.0;
}

//--------------------------------------    TableViewEditing    ---------------------------------------------
#pragma mark - TableViewEditing
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.playersArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.detailDelegate didChangeSubTableViewHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.achievement.type == LineWorth && indexPath.section == LWModifierCell)
    {
        return YES;
    }
    else if (self.achievement.type != LineWorth && indexPath.section == PlayerCell)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//-----------------------------    Add Players VC Delegate Methods   ---------------------------------------------

- (void)reload
{
    [super reload];
    NSRange range;
    if (self.achievement.type == LineWorth)
    {
        range = NSMakeRange(LWModifierCell, 1);
    }
    else
    {
        range = NSMakeRange(PlayerCell, 1);
    }

    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];

    [self.insideTableView beginUpdates];
    [self.insideTableView deleteSections:section withRowAnimation:UITableViewRowAnimationFade];
    [self.insideTableView insertSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.insideTableView endUpdates];
    [self adjustHeightOfTableview];
}

//--------------------------------------    Custom Cell Delegate Methods   --------------------------------------
#pragma mark - Custom Cell Delegate Methods
// Called when "Add" button pressed in Child cell
- (void)didPressAddButton
{
    //TODO: enable AddModifiers button when press this AddModifier button
    NSLog(@"Add Button pressed in subCell");
    [self.saveKey setString:@"YES"];
    [self.detailDelegate didPressAddButtonAtParentIndex:self.parentIndex];

    
}

- (void)didChangeSegment:(NSInteger)selectedSegment
{
    NSLog(@"Change Segment delegate called");
    NSString *tempString = [NSString stringWithFormat:@"%lu", selectedSegment];
    NSLog(@"%@", tempString);
    [self.snowIndexString setString:tempString];
}

- (void)adjustHeightOfTableview
{
    CGFloat height = self.insideTableView.contentSize.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.heightConstraint.constant = height;
        NSString *tempString = [NSString stringWithFormat:@"%f", height];
        [self.heightString setString:tempString];
    }];
    NSLog(@"Achievement Detail Height: %f", height);
}

- (void)didRemovePlayerCell:(UITableViewCell *)sender
{
    //TODO: impliment logic to remove user and users respective modifiers array from modifiers dictionary
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
