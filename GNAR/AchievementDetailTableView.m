//
//  AchievementDetailTableView.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailTableView.h"
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
        return 6;
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
            return self.modifiersArray.count;
        }
        else if (section == LWPlayerCell)
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
            infoCell.funLabel.text = @"Fun Factor: ❄︎❄︎❄︎";
            infoCell.descriptionLabel.text = @"Description: Super Awesome Saus is one of the best, most super awesome sauses around. Don't be fooled by the extreme awesomeness of the point value.";
            infoCell.difficultyLabel.text = @"Difficulty: Super Hard";
            infoCell.heroLabel.text = @"Hero Factor: 💪💪";
//            infoCell.funLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Fun Factor: %@", self.achievement[@"funFactor"]]];
//            infoCell.heroLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hero Factor: %@", self.achievement[@"heroFactor"]]];
//            infoCell.difficultyLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Difficulty: %@", self.achievement[@"difficulty"]]];
//            infoCell.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Description: %@", self.achievement[@"descriptionString"]]];

            return infoCell;
        }
        else if (indexPath.section == LWSnowCell)
        {
            SnowTableViewCell *snowCell = [tableView dequeueReusableCellWithIdentifier:@"SnowCell"];
            snowCell.delegate = self;
            snowCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            NSMutableArray *pointValues = [NSMutableArray new];
            for (int i = 0; i < self.achievement.pointValues.count; i++)
//            for (NSNumber *score in self.achievement.pointValues)
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
            snowCell.highSnowScoreLabel.text = pointValues[2];
            if ([self.snowIndexString integerValue] > 0)
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifierCell"];

            //        Score *score = self.modifiersArray[indexPath.row];
            // get achievement relation object from score object
            //        Achievement *achievement =
            //        cell.textLabel.text = score.
            //        cell.detailTextLabel.text =
            return cell;
        }
        else if (indexPath.section == LWAddModifierCell)
        {
            ModifierTableViewCell *modifierCell = [tableView dequeueReusableCellWithIdentifier:@"AddModifierCell"];
            modifierCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return modifierCell;
        }
        else if (indexPath.section == LWPlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            playersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return playersCell;
        }
        else
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlayersCell"];
            playerCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return playerCell;
            //TODO: Change "Add Players" button to "Select Players"
        }
    }


    else
    {
        if (indexPath.section == InfoCell)
        {
            //TODO: modify InfoCell to display abbreviation, point values, and description instead of all the stuff LineWorths have
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
//            infoCell.descriptionLabel.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";

//            infoCell.funLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Fun Factor: %@", self.achievement[@"funFactor"]]];
//            infoCell.heroLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hero Factor: %@", self.achievement[@"heroFactor"]]];
//            infoCell.difficultyLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Difficulty: %@", self.achievement[@"difficulty"]]];
            infoCell.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Description: %@", self.achievement[@"descriptionString"]]];
            return infoCell;
        }
        else if (indexPath.section == PlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            playersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return playersCell;
        }
        else
        {

            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlayersCell"];
//            playerCell.delegate = self;
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
        return 150.0;
    }
    else if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWAddModifierCell || indexPath.section == LWSelectPlayersCell)
        {
            return 50.0;
        }
        else if (indexPath.section == LWSnowCell)
        {
            return 75.0;
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
    [self.detailDelegate didRemovePlayerOnSwipe];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.achievement.type == LineWorth && indexPath.section == LWPlayerCell)
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
        range = NSMakeRange(LWPlayerCell, 1);
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

//--------------------------------------    Custom Cell Delegate Methods   ---------------------------------------------
#pragma mark - Custom Cell Delegate Methods
// Called when "Add" button pressed in Child cell
-(void)didPressAddButton
{
    //TODO: enable AddModifiers button when press this AddModifier button
    //TODO: close drawer when add button pressed
    NSLog(@"Add Button pressed in subCell");
    [self.saveKey setString:@"YES"];
}

-(void)didChangeSegment:(NSInteger)selectedSegment
{
    NSLog(@"Change Segment delegate called");
    NSString *tempString = [NSString stringWithFormat:@"%lu", selectedSegment];
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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
