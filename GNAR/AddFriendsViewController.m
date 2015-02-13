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

@property NSArray *tableViewArray;
@property NSArray *usersArray;
@property NSMutableArray *searchResultsArray;
@property BOOL isSearching;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableViewArray = [NSArray new];
    self.searchResultsArray = [NSMutableArray new];

    [User getAllUsers:^(NSArray *array) {
        self.usersArray = array;
        self.tableViewArray = self.usersArray;
        [self.tableView reloadData];
    }];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
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
        self.tableViewArray = self.usersArray;
    }
    else
    {
        self.isSearching = TRUE;
        for (PFUser *user in self.usersArray)
        {
            if ([[user.username lowercaseString] containsString:[searchText lowercaseString]])
            {
                [tempSearchArray addObject:user];
            }
        }
        self.tableViewArray = tempSearchArray;
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
        // Search for my crew
        [User getCurrentUserFriendsWithCompletion:^(NSArray *array) {
            self.usersArray = array;
            self.tableViewArray = self.usersArray;
            [self.tableView reloadData];
        }];
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        // Search for my facebook friends
        [User getAllFacebookUsers:^(NSArray *array) {
            self.usersArray = array;
            self.tableViewArray = self.usersArray;
            [self.tableView reloadData];
        }];
    }
    else
    {
        // Search for all GNAR users
        [User getAllUsers:^(NSArray *array) {
            self.usersArray = array;
            self.tableViewArray = self.usersArray;
            [self.tableView reloadData];
        }];
    }
}


//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    User *currentUser = self.tableViewArray[indexPath.row];
    cell.textLabel.text = currentUser.username;

    // apply checkmark to users who have already been selected
    for (PFUser *user in self.selectedUsersArray)
    {
        if ([currentUser.objectId isEqualToString:user.objectId])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedUsersArray addObject:self.tableViewArray[indexPath.row]];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsersArray removeObject:self.tableViewArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//----------------------------------------    Other    ----------------------------------------------------
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
