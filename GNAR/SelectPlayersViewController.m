//
//  SelectPlayersViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/14/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "SelectPlayersViewController.h"
#import "User.h"

@interface SelectPlayersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *displayedUsersArray;

@property NSArray *allUsersArray;
@property NSArray *facebookUsersArray;
@property NSArray *myCrewUsersArray;

@property NSMutableArray *searchResultsArray;
@property BOOL isSearching;

@end

@implementation SelectPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.displayedUsersArray = [NSArray new];


    [User getCurrentUserFriendsWithCompletion:^(NSArray *array) {
        self.myCrewUsersArray = array;
    }];
    // Search for my facebook friends
    [User getAllFacebookUsers:^(NSArray *array) {
        self.facebookUsersArray = array;
    }];
    // Search for all GNAR users
    [User getAllUsers:^(NSArray *array) {
        self.allUsersArray = array;
        self.displayedUsersArray = self.allUsersArray;
        [self.tableView reloadData];
    }];
}

//----------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    // unwind to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayedUsersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    User *currentUser = self.displayedUsersArray[indexPath.row];
    // Set cell title to user's name
    if ([currentUser.objectId isEqual:[User currentUser].objectId])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (me)", currentUser.username];

    }
    else
    {
        cell.textLabel.text = currentUser.username;
    }

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // apply checkmark to users who have already been selected
    for (PFUser *user in self.selectedUsersArray)
    {
        if ([currentUser.objectId isEqualToString:user.objectId])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = self.displayedUsersArray[indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.objectId == %@", user.objectId];
    NSArray *filtered = [self.selectedUsersArray filteredArrayUsingPredicate:predicate];
    if (filtered.count > 0)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsersArray removeObject:filtered.firstObject];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedUsersArray addObject:self.displayedUsersArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
