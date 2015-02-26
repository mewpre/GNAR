//
//  UserAchievementsViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "UserAchievementsViewController.h"
#import "Achievement.h"
#import "SuggestedTableViewCell.h"

@interface UserAchievementsViewController () <UITableViewDataSource, UITableViewDelegate, SuggestedTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIRefreshControl *refreshControl;
@property NSMutableArray *scoresArray;
@property NSMutableArray *suggestedScoresArray;

@end

@implementation UserAchievementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Display current User's username in title
    self.title = [NSString stringWithFormat:@"%@", self.currentPlayer.username];
    self.scoresArray = [NSMutableArray new];
    self.suggestedScoresArray = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    // Display the scores of the current user
    [self getUserScoresWithCompletion:^(NSArray *scores) {

        NSLog(@"Fetched %lu scores for %@", scores.count, self.currentPlayer);
        for (Score *score in scores)
        {
            if ([score.isConfirmed boolValue])
            {
                [self.scoresArray addObject:score];
            }
            else
            {
                // Only show suggested scores for current user, not all users
                if ([self.currentPlayer.objectId isEqual:[User currentUser].objectId])
                {
                    [self.suggestedScoresArray addObject:score];
                }
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self getUserScoresWithCompletion:^(NSArray *scores) {
        [refreshControl endRefreshing];
    }];
}

//--------------------------------------    Helper Methods    ---------------------------------------------
#pragma mark - Helper Methods
// Retrieves scores for a specified user within a specified game (includes score modifiers with fetch)
- (void)getUserScoresWithCompletion:(void(^)(NSArray *scores))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Score"];
    // Player-specific query
    [query whereKey:@"scorer" equalTo:(User *)self.currentPlayer];
    // Game-specific query
    [query whereKey:@"game" equalTo:self.currentGame];
    // Order scores by createdAt Date
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"achievementPointer"];
    //    [query includeKey:@"modifiers"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            complete(objects);
        }
    }];
}


//----------------------------------------    Table View    ------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.suggestedScoresArray.count;
    }
    else
    {
        return self.scoresArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SuggestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCell"];
        cell.acceptButton.tag = indexPath.row;
        cell.declineButton.tag = indexPath.row;
        cell.delegate = self;
        Score *score = self.suggestedScoresArray[indexPath.row];
        Achievement *scoreAchievement = score[@"achievementPointer"];
        cell.scoreNameLabel.text = scoreAchievement.name;
        cell.scoreDetailLabel.text = [NSString stringWithFormat:@"%@", scoreAchievement.pointValues[score.snowLevel.intValue]];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmedCell"];
        cell.textLabel.textColor = [UIColor whiteColor];

        Score *score = self.scoresArray[indexPath.row];

        Achievement *scoreAchievement = score[@"achievementPointer"];

        cell.textLabel.text = scoreAchievement.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", scoreAchievement.pointValues[score.snowLevel.intValue]];

        //    NSArray *modifiersArray = [score objectForKey:@"modifiers"];
        //    Score *modifier = ;
        return cell;
    }
}

- (void)didPressAcceptButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    Score *acceptedScore = [self.suggestedScoresArray objectAtIndex:indexPath.row];

    acceptedScore.isConfirmed = [NSNumber numberWithBool:YES];
    [acceptedScore saveInBackground];

    [self.suggestedScoresArray removeObjectAtIndex:indexPath.row];
    //TODO: Do we even need the following line? Reloading the data should change the number of cells.
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.scoresArray addObject:acceptedScore];
    [self.tableView reloadData];
}

- (void)didPressDeclineButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    Score *declinedScore = [self.suggestedScoresArray objectAtIndex:indexPath.row];

    [declinedScore deleteInBackground];
    [self.suggestedScoresArray removeObjectAtIndex:indexPath.row];
    //TODO: Do we even need the following line? Reloading the data should change the number of cells.
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.suggestedScoresArray.count != 0)
    {
        return @"Suggested Scores";
    }
    else if (section == 1)
    {
        return @"Confirmed Scores";
    }
    else
    {
        return nil;
    }
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
