//
//  GamesViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GamesViewController.h"
#import "AddGameTableViewController.h"
#import "GameManager.h"
#import "User.h"
#import "Game.h"
#define kGameIdKey @"CurrentGameId"

@interface GamesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

//@property GameManager *gameManager;

@property NSArray *gamesArray;
//@property Game *currentGame;

@property UIRefreshControl *refreshControl;
@property NSUserDefaults *defaults;

@end

@implementation GamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[GameManager sharedManager] printCurrentGame];

    self.defaults = [NSUserDefaults standardUserDefaults];

    // refresh control used for pull-down to refresh functionality
    self.refreshControl = [[UIRefreshControl alloc] init];
    // since this is not a table view controller, need to programatically create link between VC and refresh control
    [self.refreshControl addTarget:self action:@selector(getCurrentUserGamesWithCompletion:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.backgroundColor = [UIColor colorWithWhite:( 30/255.0) alpha:1.0];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Current game: %@", [GameManager sharedManager].currentGame.name);

    // Get current game object from core data singleton
//    self.currentGame = self.gameManager.currentGame;

    [self.segmentedControl setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    //    NSLog(@"%@", [User currentUser].username);


//    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
//    [query fromLocalDatastore];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        Game *game = object;
//        self.currentGame = game;
//    }];

    [User getCurrentUserGamesWithCompletion:^(NSArray *currentUserGames) {
        self.gamesArray = currentUserGames;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.activitySpinner stopAnimating];

//        [PFObject pinAllInBackground:self.gamesArray withName:@"UserGames" block:^(BOOL succeeded, NSError *error) {
//            NSLog(@"Successfully pinned %lu games in background.", (unsigned long)self.gamesArray.count);
//            [self.tableView reloadData];
//            [self.refreshControl endRefreshing];
//            [self.activitySpinner stopAnimating];
//
//        }];
    }];
//    [self getCurrentUserGames];
}

//--------------------------------------    Actions    ---------------------------------------------
#pragma mark - Actions

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    // Start activity spinner
    [self.activitySpinner startAnimating];
    if (sender.selectedSegmentIndex == 0)
    {
        // Display games I (current user) am a player in
        [User getCurrentUserGamesWithCompletion:^(NSArray *currentUserGames) {
            self.gamesArray = currentUserGames;
            [self.tableView reloadData];
            [self.activitySpinner stopAnimating];
        }];
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        // Get all friends

        // Display games my friends have created and I'm not in

        [self.tableView reloadData];
        [self.activitySpinner stopAnimating];
    }
    else
    {
        // Display all games
        [Game getAllGames:^(NSArray *allGames) {
            self.gamesArray = allGames;
            [self.tableView reloadData];
            [self.activitySpinner stopAnimating];
        }];
    }
}


////--------------------------------------    Helper Methods   ---------------------------------------------
//#pragma mark - Helper Methods
////Helper method for refresh control
//- (void)getCurrentUserGames:(void(^)(NSArray *currentUserGames))complete
//{
//    [User getCurrentUserGamesWithCompletion:^(NSArray *array) {
////        self.gamesArray = array;
//        complete()
//
////        for (Game *game in self.gamesArray)
////        {
////            [game getPlayersOfGameWithCompletion:^(NSArray *array) {
////                game.players = array;
////                [game pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////                    NSLog(@"Pinned game in background: %@", game.name);
////                }];
////            }];
////        }
//        [self.tableView reloadData];
//        [self.refreshControl endRefreshing];
//        [self.activitySpinner stopAnimating];
//    }];
//}


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
    Game *game = self.gamesArray[indexPath.row];


    // Set cell title to game's mountain
    cell.textLabel.text = [game objectForKey:@"name"];
    // Set users in game
    NSString *playersNames = [self createPlayersStringWithGame:game];
    cell.detailTextLabel.text = playersNames;
    // Set number of detailText lines to fit all the players
//    cell.detailTextLabel.numberOfLines = game.players.count;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game *selectedGame = self.gamesArray[[self.tableView indexPathForSelectedRow].row];

    //TODO: Add alert to ask if you want to officially change games

    // Save game to NSUserDefaults
//    [selectedGame saveGame];

    // Save game objectID to NSUserDefaults
    NSString *gameId = selectedGame.objectId;
    [self.defaults setObject:gameId forKey:kGameIdKey];
    [self.defaults synchronize];

    // Save Game to NSUserDefaults
    [selectedGame saveGame];

    // Set current game to selectedGame
    [GameManager sharedManager].currentGame = selectedGame;

    NSLog(@"%@", [GameManager sharedManager].currentGame.name);
//    [self.gameManager.currentGame getGameWithCompletion:^(Game *game) {
//        // Save game as singleton in Core Data
//        self.gameManager.currentGame = game;
//    }];
//    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}


//--------------------------------------    Helper Methods    ---------------------------------------------
#pragma mark - Helper Methods

- (NSString *)createPlayersStringWithGame:(Game *)game
{
    NSMutableString *playersString = [NSMutableString new];
#warning This uses game.playersArray which is local only...find way to use only relation???
    for (int i = 0; i < game.playersArray.count; i++)
    {
#warning This uses game.playersArray which is local only...find way to use only relation???
        User *user = game.playersArray[i];
        [playersString appendString:user.username];
//        [playersString appendString:@"\n"];
    }
    return playersString;
}


//-------------------------------------    Prepare for Segue    ----------------------------------------------------
#pragma mark - Table View
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewGameSegue"])
    {
        AddGameTableViewController *addGameVC = segue.destinationViewController;
        Game *selectedGame = self.gamesArray[[self.tableView indexPathForSelectedRow].row];
        addGameVC.selectedGame = selectedGame;
    }
    else
    {

    }
}













@end
