//
//  LeaderboardViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "UserAchievementsViewController.h"
#import "GameManager.h"
#import "LeaderboardTableViewCell.h"

@interface LeaderboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (weak, nonatomic) IBOutlet UILabel *myUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRankLabel;

@property UIRefreshControl *refreshControl;
@property NSArray *playersArray;
@property NSArray *sortedPlayersArray;
@property Game *currentGame;
@property NSArray *playerScoresArray;

@property NSMutableDictionary *playersScoresData;
@property NSMutableDictionary *playersTotalScoresData;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GameManager sharedManager] printCurrentGame];
    // refresh control used for pull-down to refresh functionality
    self.refreshControl = [[UIRefreshControl alloc] init];
    // since this is not a table view controller, need to programatically create link between VC and refresh control
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Get current game object from core data singleton
    self.currentGame = [GameManager sharedManager].currentGame;

    // Get scores of current user

    // Get players within current game
    [self.currentGame getPlayersOfGameWithCompletion:^(NSArray *players) {
        self.playersArray = players;


        [self.playersScoresData setObject:players forKey:@"playersArray"];

        for (User *user in self.playersArray)
        {
            // Get scores of USER for GAME

            [self getUserScores:user forGame:self.currentGame withCompletion:^(NSArray *userScores) {
                // Set up dictionary to hold players (and then scores later)
                self.playersScoresData = [NSMutableDictionary new];
                self.playersTotalScoresData = [NSMutableDictionary new];
                // Set fetched scores to local object.scores
                //TODO: change this to GQL local data storage
                [self.playersScoresData setObject:userScores forKey:user.username];
                NSInteger tempScore = 0;
                for (Score *score in userScores)
                {
                    tempScore = tempScore + [score.score integerValue];
                }
                NSNumber *totalScore = [NSNumber numberWithInteger:tempScore];
                [self.playersTotalScoresData setObject:totalScore forKey:user.username];
                [self sortPlayerTotalDictionary];
                [self.tableView reloadData];
                [self.activitySpinner stopAnimating];

                // Set My GNAR score at top of VC
//                self.myUserNameLabel.text = [User currentUser].username;
//                self.myScoreLabel.text = self.playersTotalScoresData[[User currentUser].username];
//                self.myRankLabel.text =
            }];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//--------------------------------------    Helper Methods    ---------------------------------------------
#pragma mark - Helper Methods
- (void)getUserScores:(User *)user forGame:(Game *)game withCompletion:(void(^)(NSArray *userScores))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Score"];
    [query whereKey:@"scorer" equalTo:user];
    [query whereKey:@"game" equalTo:game];
    [query includeKey:@"Modifiers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Fetched %lu scores for %@", (unsigned long)objects.count, self);
        }
        complete(objects);
    }];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedPlayersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeaderboardCell"];

    if (self.playersTotalScoresData)
    {
        NSString *username = self.sortedPlayersArray[indexPath.row];
        //    User *user = self.playersArray[indexPath.row];
        cell.userNameLabel.text = username;
        cell.scoreLabel.text = self.playersTotalScoresData[username];
        //    cell.rankLabel =
        //    cell.scoreRatioLabel =
    }

//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.playersTotalScoresData objectForKey:username]];
//    cell.textLabel.text = username;
//    cell.textLabel.textColor = [UIColor whiteColor];

    return cell;
}



//----------------------------------------    Prepare for Segue    ----------------------------------------------------
#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@""])
    {
        UserAchievementsViewController *userAchieveVC = segue.destinationViewController;

//        userAchieveVC.scoresArray = self.playersArray[[self.tableView indexPathForSelectedRow].row][@"scores"];

        NSString *selectedUsername = self.sortedPlayersArray[[self.tableView indexPathForSelectedRow].row];
        for (User *user in self.playersArray)
        {
            if ([selectedUsername isEqualToString:user.username])
            {
                userAchieveVC.currentPlayer = user;
            }
        }
        userAchieveVC.currentGame = self.currentGame;
    }
//    else
    {

    }
}



- (void) sortPlayerTotalDictionary
{
    //TODO: Should have the cells contain users instead of just the 
    self.sortedPlayersArray = [self.playersTotalScoresData keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        // Switching the order of the operands reverses the sort direction
        return [obj2 compare:obj1];
    }];
    
}






    
    
    
    
    
    
    @end
