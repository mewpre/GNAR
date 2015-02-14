//
//  AddAchievementTableViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddAchievementViewController.h"
#import "AddPlayersViewController.h"
#import "User.h"
#import "Score.h"
#import "Enum.h"

@interface AddAchievementViewController () <UITableViewDataSource, UITableViewDelegate, InfoTableViewCellDelegate, SnowTableViewCellDelegate, ModifierTableViewCellDelegate, PlayerTableViewCellDelegate, AddPlayersDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddAchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.modifiersArray = [NSMutableArray new];
    self.playersArray = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser], nil];

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
        NSLog(@"Section: %li", section);
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
        NSLog(@"Section: %ld  Row: %ld", (long)indexPath.section, (long)indexPath.row);
        if (indexPath.section == LWInfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionLabel.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";


            //        infoCell.funLabel.attributedText = [NSAttributedString stringWithFormat:@"Fun Factor: ", self.selectedAchievement.funFactor];
            //        infoCell.heroLabel.attributedText = [NSAttributedString stringWithFormat:@"Hero Factor: ", self.selectedAchievement.heroFactor];
            //        infoCell.difficultyLabel.attributedText = [NSAttributedString stringWithFormat:@"Difficulty: ", self.selectedAchievement.difficulty];
            //        infoCell.descriptionTextView.attributedText = [NSAttributedString stringWithFormat:@"Description: ", self.selectedAchievement.description];
            return infoCell;
        }
        else if (indexPath.section == LWSnowCell)
        {
            SnowTableViewCell *snowCell = [tableView dequeueReusableCellWithIdentifier:@"SnowCell"];
            snowCell.delegate = self;
            snowCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            NSMutableArray *pointValues = [NSMutableArray new];
            for (NSNumber *score in self.achievement.pointValues)
            {
                if ([score integerValue] == 0)
                {
                    [pointValues addObject:@"NR"];
                    [snowCell.segmentedControl setEnabled:NO forSegmentAtIndex:[self.achievement.pointValues indexOfObject:score]];
                }
                else
                {
                    [pointValues addObject:[NSString stringWithFormat:@"%@", score]];
                }
            }
            snowCell.lowSnowScoreLabel.text = pointValues[0];
            snowCell.medSnowScoreLabel.text = pointValues[1];
            snowCell.highSnowScoreLabel.text = pointValues[2];

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
            modifierCell.delegate = self;
            modifierCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return modifierCell;
        }
        else if (indexPath.section == LWPlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            return playersCell;
        }
        else
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"AddPlayerCell"];
            playerCell.delegate = self;
            playerCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return playerCell;
        }
    }
    else
    {
        if (indexPath.section == InfoCell)
        {
            //TODO: modify InfoCell to display abbreviation and description instead of all the stuff LineWorths have
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionLabel.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";
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
            playerCell.delegate = self;
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
        if (indexPath.section == LWAddModifierCell || indexPath.section == LWAddPlayerCell)
        {
            return 50.0;
        }
        else if (indexPath.section == LWSnowCell)
        {
            return 75.0;
        }
    }
    else if (indexPath.section == AddPlayerCell)
    {
        return 50.0;
    }
    return 45.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddPlayersViewController *addVC = segue.destinationViewController;
    addVC.selectedUsersArray = self.playersArray;
}


- (void)addFriendsSaveButtonPressed:(NSArray *)selectedUsersArray
{
//    NSMutableArray *deleteArray = [NSMutableArray new];
//    for (int i = 0; i < self.playersArray.count; i++)
//    {
//        [deleteArray addObject:[NSIndexPath indexPathForRow:i inSection:4]];
//    }
//    NSMutableArray *insertArray = [NSMutableArray new];
//    for (int i = 0; i < selectedUsersArray.count; i++)
//    {
//        [insertArray addObject:[NSIndexPath indexPathForRow:i inSection:4]];
//    }
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationRight];
//    self.playersArray = selectedUsersArray;
//    [self.tableView endUpdates];
#warning FIX THIS!!!


////    NSInteger diff = selectedUsersArray.count - self.playersArray.count;
//    self.playersArray = selectedUsersArray;
//    NSRange range = NSMakeRange(4, 1);
//    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
////    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
//
////    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteSections:section withRowAnimation:UITableViewRowActionStyleDestructive];
//    [self.tableView insertSections:section withRowAnimation:UITableViewRowActionStyleNormal];
//    [self.tableView endUpdates];

}

//--------------------------------------    Custom Cell Delegate Methods   ---------------------------------------------
#pragma mark - Custom Cell Delegate Methods

-(void)didPressAddButton
{
    NSLog(@"Add Button delegate called");
}

-(void)didPressAddModifiersButton
{
    NSLog(@"Add Modifiers Button delegate called");
}

-(void)didPressAddPlayersButton
{
    NSLog(@"Add Players Button delegate called");
}

-(void)didChangeSegment:(NSInteger)selectedSegment
{
    NSLog(@"Change Segment delegate called");
}

@end
