//
//  GamesViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GamesViewController.h"
#import "LeaderboardViewController.h"
#import "User.h"

@interface GamesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property NSArray *gamesArray;

@property UIRefreshControl *refreshControl;

@end

@implementation GamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // refresh control used for pull-down to refresh functionality
    self.refreshControl = [[UIRefreshControl alloc] init];
    // since this is not a table view controller, need to programatically create link between VC and refresh control
    [self.refreshControl addTarget:self action:@selector(getCurrentUserGames) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.backgroundColor = [UIColor colorWithWhite:( 30/255.0) alpha:1.0];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentedControl setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
//    NSLog(@"%@", [PFUser currentUser].username);
    [self getCurrentUserGames];
}

//--------------------------------------    Helper Methods   ---------------------------------------------
#pragma mark - Helper Methods
//Helper method for refresh control
- (void)getCurrentUserGames
{
    [User getCurrentUserGamesWithCompletion:^(NSArray *array) {
        self.gamesArray = array;
//        Game *firstGame = self.gamesArray.firstObject;
//        NSArray *playersArray = [firstGame objectForKey:@"players"];
//        PFObject *player = playersArray.firstObject;
//        NSLog(@"Fetched %lu players from first game", playersArray.count);


        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.activitySpinner stopAnimating];
    }];
}



//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gamesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    // Get game object for current cell
    PFObject *game = self.gamesArray[indexPath.row];

    // Set cell title to game's mountain
    cell.textLabel.text = [game objectForKey:@"name"];
    // Set users in game
    NSString *mountain = [NSString stringWithFormat:@"%@", game[@"mountain"]];
    cell.detailTextLabel.text = mountain;
    return cell;
}


//-------------------------------------    Prepare for Segue    ----------------------------------------------------
#pragma mark - Table View
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewGameSegue"])
    {
        LeaderboardViewController *leaderVC = segue.destinationViewController;
        Game *selectedGame = self.gamesArray[[self.tableView indexPathForSelectedRow].row];
        leaderVC.currentGame = selectedGame;
    }
    else
    {

    }
}













@end
