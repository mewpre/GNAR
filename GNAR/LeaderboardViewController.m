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

@interface LeaderboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (weak, nonatomic) IBOutlet UILabel *myUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRankLabel;

@property UIRefreshControl *refreshControl;
@property NSArray *playersArray;
@property Game *currentGame;
@property NSArray *playerScoresArray;

@property NSMutableDictionary *playersScoresData;

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

        // Set up dictionary to hold players (and then scores later)
        self.playersScoresData = [NSMutableDictionary new];
        [self.playersScoresData setObject:players forKey:@"playersArray"];

        // Get scores for all other players within current game

//        [self getScoresForUsers:players forGame:self.currentGame withCompletion:^(NSArray *playersScores) {
//            self.playerScoresArray = playersScores;
//        }];



        for (User *user in self.playersArray)
        {
            // Get scores of USER for GAME


            [self getUserScores:user forGame:self.currentGame withCompletion:^(NSArray *userScores) {
                // Set fetched scores to local object.scores
                //TODO: change this to GQL local data storage
//                [user.scores addObjectsFromArray:userScores];
                [self.playersScoresData setObject:userScores forKey:user.username];

                [self.tableView reloadData];
                [self.activitySpinner stopAnimating];
            }];
        }
    }];
}

//--------------------------------------    Helper Methods    ---------------------------------------------
#pragma mark - Helper Methods
//- (void)getScoresForUsers:(NSArray *)users forGame:(Game *)game withCompletion:(void(^)(NSArray *playersScores))complete
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"Score"];
//    [query whereKey:@"scorer" containedIn:users];
//    [query whereKey:@"game" equalTo:game];
//    [query includeKey:@"Modifiers"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//        else
//        {
//            NSLog(@"Fetched %lu scores for %@", (unsigned long)objects.count, self);
//        }
//        complete(objects);
//    }];
//}

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
    return self.playersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *playersArray = [self.playersScoresData objectForKey:@"playersArray"];
    User *player = playersArray[indexPath.row];
    int totalScore = 0;
    for (Score *score in [self.playersScoresData objectForKey:player.username])
    {
        totalScore = totalScore + [score.score intValue];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", totalScore];
    cell.textLabel.text = [self.playersArray[indexPath.row] username];
    cell.textLabel.textColor = [UIColor whiteColor];
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
        userAchieveVC.currentPlayer = self.playersArray[[self.tableView indexPathForSelectedRow].row];
        userAchieveVC.currentGame = self.currentGame;
    }
//    else
    {

    }
}










    
    
    
    
    
    
    @end
