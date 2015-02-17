//
//  LeaderboardViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "UserAchievementsViewController.h"

@interface LeaderboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property UIRefreshControl *refreshControl;
@property NSArray *playersArray;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.currentGame getPlayersOfGameWithCompletion:^(NSArray *array) {
        self.playersArray = array;
        [self.tableView reloadData];
        [self.activitySpinner stopAnimating];
    }];

    // refresh control used for pull-down to refresh functionality
    self.refreshControl = [[UIRefreshControl alloc] init];
    // since this is not a table view controller, need to programatically create link between VC and refresh control
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
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
