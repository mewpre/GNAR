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

    Achievement *dailyECP = [Achievement new];
    dailyECP[@"name"] = @"Mom Line";
    dailyECP[@"abbreviation"] = @"ML";
    dailyECP[@"description"] = @"Talking to your mother on a cell phone (without headset), stick line worth 500 or greater.";
    dailyECP[@"pointValues"] = @[@7000];

    [dailyECP saveInBackground];

    Achievement *unlimitedECP = [Achievement new];
    unlimitedECP[@"name"] = @"Ego Claim";
    unlimitedECP[@"abbreviation"] = @"EG";
    unlimitedECP[@"description"] = @"After skiing a designated line, go over to a group of strangers who were watching and claim, \"I'm the best skier on the mountain!\"";
    unlimitedECP[@"pointValues"] = @[@500];
    [unlimitedECP saveInBackground];

    Achievement *yearlyECP = [Achievement new];
    yearlyECP[@"name"] = @"Cushing Pond";
    yearlyECP[@"abbreviation"] = @"CP";
    yearlyECP[@"description"] = @"Cross meltin Cushing Pond";
    yearlyECP[@"pointValues"] = @[@8000];
    [yearlyECP saveInBackground];

   // Achievement *lineWorth = [Achievement new];

    

    //    Game *game = [Game new];
    //    game[@"name"] = @"My First Game";
    //    game[@"mountain"] = @"Vail";
    //    game[@"startDate"] = [NSDate new];
    //    game[@"endDate"] = [NSDate new];
    //
    //    PFRelation *playersRelation = [game relationForKey:@"players"];
    //    [playersRelation addObject:[PFUser currentUser]];
    //    PFRelation *creatorRelation = [game relationForKey:@"creator"];
    //    [creatorRelation addObject:[PFUser currentUser]];
    //
    //    [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    //    {
    //        PFRelation *gamesRelation = [[PFUser currentUser] relationForKey:@"games"];
    //        [gamesRelation addObject:game];
    //        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    //        {
    //            // unwind segue to previous view controller
    //            [self.navigationController popViewControllerAnimated:YES];
    //
    //        }];
    //    }];
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
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
