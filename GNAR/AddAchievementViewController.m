//
//  AddAchievementTableViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddAchievementViewController.h"
#import "User.h"
#import "Score.h"
#import "Enum.h"

@interface AddAchievementViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddAchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.modifiersArray = [NSMutableArray new];
    self.playersArray = [NSMutableArray new];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//--------------------------------------    Table View Data Source    ---------------------------------------------
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.achievement.type == LineWorth)
    {
        return 6;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWInfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionTextView.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";
            //        infoCell.funLabel.attributedText = [NSAttributedString stringWithFormat:@"Fun Factor: ", self.selectedAchievement.funFactor];
            //        infoCell.heroLabel.attributedText = [NSAttributedString stringWithFormat:@"Hero Factor: ", self.selectedAchievement.heroFactor];
            //        infoCell.difficultyLabel.attributedText = [NSAttributedString stringWithFormat:@"Difficulty: ", self.selectedAchievement.difficulty];
            //        infoCell.descriptionTextView.attributedText = [NSAttributedString stringWithFormat:@"Description: ", self.selectedAchievement.description];
            return infoCell;
        }
        else if (indexPath.section == LWSnowCell)
        {
            SnowTableViewCell *snowCell = [tableView dequeueReusableCellWithIdentifier:@"SnowCell"];
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
            return modifierCell;
        }
        else if (indexPath.section == LWPlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            //        playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            return playersCell;
        }
        else
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"AddPlayerCell"];
            return playerCell;
        }
    }
    else
    {
        if (indexPath.section == InfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionTextView.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";
            //        infoCell.funLabel.attributedText = [NSAttributedString stringWithFormat:@"Fun Factor: ", self.selectedAchievement.funFactor];
            //        infoCell.heroLabel.attributedText = [NSAttributedString stringWithFormat:@"Hero Factor: ", self.selectedAchievement.heroFactor];
            //        infoCell.difficultyLabel.attributedText = [NSAttributedString stringWithFormat:@"Difficulty: ", self.selectedAchievement.difficulty];
            //        infoCell.descriptionTextView.attributedText = [NSAttributedString stringWithFormat:@"Description: ", self.selectedAchievement.description];
            return infoCell;
        }
        else if (indexPath.section == PlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            //        playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            return playersCell;
        }
        else // AddPlayerCell
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"AddPlayerCell"];
            return playerCell;
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
