//
//  GamesViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "GamesViewController.h"
#import "User.h"

@interface GamesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property NSArray *gamesArray;

@end

@implementation GamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [PFUser currentUser].username);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", [PFUser currentUser].username);
    [User getCurrentUserGamesWithCompletion:^(NSArray *array) {
        self.gamesArray = array;
        [self.tableView reloadData];
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
    cell.textLabel.text = [game objectForKey:@"mountain"];
    return cell;
}


//-------------------------------------    Prepare for Segue    ----------------------------------------------------
#pragma mark - Table View
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddGameSegue"])
    {
        
    }
    else
    {

    }
}






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
