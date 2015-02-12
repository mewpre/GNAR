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

@property NSArray *usersArray;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [User getAllUsers:^(NSArray *array) {
        self.usersArray = array;
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

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        // Search for my crew

    }
    else if (sender.selectedSegmentIndex == 1)
    {
        // Search for my facebook friends
        [User getAllFacebookUsers:^(NSArray *array) {
            self.usersArray = array;
            [self.tableView reloadData];
        }];
    }
    else
    {
        // Search for all GNAR users
        [User getAllUsers:^(NSArray *array) {
            self.usersArray = array;
            [self.tableView reloadData];
        }];
    }
}


//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    User *currentUser = self.usersArray[indexPath.row];
    cell.textLabel.text = currentUser.username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.playersArray addObject:self.usersArray[indexPath.row]];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.playersArray removeObject:self.usersArray[indexPath.row]];
    }
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
