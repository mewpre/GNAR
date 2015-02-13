//
//  AddFriendsViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "User.h"

@interface AddFriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property NSArray *displayedUsersArray;
@property NSArray *currentArray;

@property NSArray *allUsersArray;
@property NSArray *facebookUsersArray;
@property NSArray *myCrewUsersArray;

@property NSMutableArray *searchResultsArray;
@property BOOL isSearching;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.displayedUsersArray = [NSArray new];
    self.searchResultsArray = [NSMutableArray new];


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
        self.currentArray = self.allUsersArray;
        [self.tableView reloadData];
    }];




    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    self.navigationController.navigationBar.topItem.title = @"Cancel";
}

- (void)hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

//--------------------------------------    Search Bar    ----------------------------------------------------
#pragma mark - Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempSearchArray = [NSMutableArray new];
    if ([searchText isEqualToString:@""])
    {
        self.isSearching = FALSE;
        self.displayedUsersArray = self.currentArray;
    }
    else
    {
        self.isSearching = TRUE;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@",searchText];
        tempSearchArray = [NSMutableArray arrayWithArray:[self.currentArray filteredArrayUsingPredicate:predicate]];
        self.displayedUsersArray = tempSearchArray;
    }
    [self.tableView reloadData];
}


//----------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate addFriendsSaveButtonPressed:self.selectedUsersArray];
    // unwind to previous view controller
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    if (sender.selectedSegmentIndex == 0)
    {
        // Display my crew
        self.displayedUsersArray = self.myCrewUsersArray;
        self.currentArray = self.myCrewUsersArray;
        [self.tableView reloadData];
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        // Display my facebook friends
        self.displayedUsersArray = self.facebookUsersArray;
        self.currentArray = self.facebookUsersArray;
        [self.tableView reloadData];
    }
    else
    {
        // Search for all GNAR users
        self.displayedUsersArray = self.allUsersArray;
        self.currentArray = self.allUsersArray;
        [self.tableView reloadData];
    }
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
    cell.textLabel.text = currentUser.username;

    // apply checkmark to users who have already been selected
    for (PFUser *user in self.selectedUsersArray)
    {
        if ([currentUser.objectId isEqualToString:user.objectId])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedUsersArray containsObject:self.displayedUsersArray[indexPath.row]])
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsersArray removeObject:self.displayedUsersArray[indexPath.row]];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedUsersArray addObject:self.displayedUsersArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

















@end
