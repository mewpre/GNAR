//
//  UserAchievementsViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "UserAchievementsViewController.h"

@interface UserAchievementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIRefreshControl *refreshControl;
@property NSArray *scoresArray;

@end

@implementation UserAchievementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [User getUserScoresWithCompletion:^(NSArray *array) {
        self.scoresArray = array;
        [self.tableView reloadData];
    }];



    // Do any additional setup after loading the view.
    self.refreshControl = [[UIRefreshControl alloc] init];
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
    return self.scoresArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Score *score = self.scoresArray[indexPath.row];
//    NSLog(@"%@", score);
    NSArray *modifiersArray = [score objectForKey:@"modifiers"];
//    Score *modifier = ;
    cell.textLabel.text = @"10,000";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", score.score];
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
