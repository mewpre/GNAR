//
//  HomeViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "GameManager.h"


@interface HomeViewController ()<LoginViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property LoginViewController *loginVC;
//@property Game *currentGame;
//@property GameManager *gameManager;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![GameManager sharedManager].currentGame)
    {
        //TODO: decide which game to pull here (change getCurrentGameWithCompletion method) OR ask user to create or select game?
        [Game getCurrentGameWithCompletion:^(Game *currentGame) {
            // Set game object to singleton
            [GameManager sharedManager].currentGame = currentGame;
            NSLog(@"Fetched game: %@", [GameManager sharedManager].currentGame.name);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", [PFUser currentUser].username];
}


- (IBAction)onLogoutButtonPressed:(id)sender
{
    [PFUser logOut];
    NSLog(@"Logged Out");
    self.loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.loginVC.delegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action: @selector(onSignUpButtonPressed)];
    self.loginVC.navigationItem.rightBarButtonItem = rightButton;
    [self presentViewController:navCon animated:NO completion:nil];
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"logged in as: %@", [PFUser currentUser].username);
    self.tabBarController.selectedIndex = 1;
}

- (void) onSignUpButtonPressed
{
    [self.loginVC performSegueWithIdentifier:@"SignUpSegue" sender:self];
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
