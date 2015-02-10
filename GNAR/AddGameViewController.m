//
//  AddGameViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddGameViewController.h"
#import <Parse/Parse.h>

@interface AddGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *addGameArray;

@end

@implementation AddGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.addGameArray = [[NSArray alloc] initWithObjects:@"Friends", @"Mountains", @"Start Date", @"End Date", nil];
}


//----------------------------------------    Done Button    ----------------------------------------------------
#pragma mark - Done Button
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    // Create default game for testing
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    game[@"name"] = @"My First Game";
    game[@"mountain"] = @"Vail";
    game[@"startDate"] = [NSDate new];
    game[@"endDate"] = [NSDate new];

    [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[PFUser currentUser] addObject:game forKey:@"games"];



        // Fix relationship and call



        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // unwind segue to previous view controller
            [self.navigationController popViewControllerAnimated:YES];

        }];
    }];

}

//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addGameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.addGameArray[indexPath.row];
    return cell;
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
