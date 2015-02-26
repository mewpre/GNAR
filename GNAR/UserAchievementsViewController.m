//
//  UserAchievementsViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "UserAchievementsViewController.h"
#import "Achievement.h"
#import "UserAchievementsTableViewCell.h"

@interface UserAchievementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIRefreshControl *refreshControl;
@property NSMutableArray *scoresArray;
@property NSMutableArray *suggestedScoresArray;

@end

@implementation UserAchievementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Display current User's username in title
    self.title = [NSString stringWithFormat:@"%@", self.currentPlayer.username];
    self.scoresArray = [NSMutableArray new];
    self.suggestedScoresArray = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    // Display the scores of the current user
    [self getUserScoresWithCompletion:^(NSArray *scores) {

        NSLog(@"Fetched %lu scores for %@", scores.count, self.currentPlayer);
        for (Score *score in scores)
        {

            if (score.isConfirmed)
            {
                [self.scoresArray addObject:score];
            }
            else
            {
                [self.suggestedScoresArray addObject:score];
            }
        }

        [self.tableView reloadData];

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self getUserScoresWithCompletion:^(NSArray *scores) {
        [refreshControl endRefreshing];
    }];
}

//--------------------------------------    Helper Methods    ---------------------------------------------
#pragma mark - Helper Methods
// Retrieves scores for a specified user within a specified game (includes score modifiers with fetch)
- (void)getUserScoresWithCompletion:(void(^)(NSArray *scores))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Score"];
    // Player-specific query
    [query whereKey:@"scorer" equalTo:(User *)self.currentPlayer];
    // Game-specific query
    [query whereKey:@"game" equalTo:self.currentGame];
    // Order scores by createdAt Date
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"achievementPointer"];
    //    [query includeKey:@"modifiers"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            complete(objects);
        }
    }];
}


//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoresArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UserAchievementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        Score *score = self.suggestedScoresArray[indexPath.row];

        Achievement *scoreAchievement = score[@"achievementPointer"];

        cell.textLabel.text = scoreAchievement.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", scoreAchievement.pointValues[score.snowLevel.intValue]];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmedCell"];
        cell.textLabel.textColor = [UIColor whiteColor];

        Score *score = self.scoresArray[indexPath.row];

        Achievement *scoreAchievement = score[@"achievementPointer"];

        cell.textLabel.text = scoreAchievement.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", scoreAchievement.pointValues[score.snowLevel.intValue]];

        //    NSArray *modifiersArray = [score objectForKey:@"modifiers"];
        //    Score *modifier = ;
        return cell;
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
