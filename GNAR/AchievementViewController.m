//
//  AchievementViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementViewController.h"
#import "Achievement.h"
#import "User.h"

@interface AchievementViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *achievementsArray;

@end

@implementation AchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

        // Create achievements for testing

    [User getAchievementsWithCompletion:^(NSArray *array)
    {
        self.achievementsArray = array;
        [self.tableView reloadData];
    }];
    
}

//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.achievementsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    // Get game object for current cell
    PFObject *achievement = self.achievementsArray[indexPath.row];

    // Set cell title to game's mountain
    cell.textLabel.text = [achievement objectForKey:@"name"];
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
