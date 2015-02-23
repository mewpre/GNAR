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
#import "User.h"
#import "AppDelegate.h"
#define kGameIdKey @"CurrentGameId"


@interface HomeViewController ()<LoginViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property LoginViewController *loginVC;
//@property Game *currentGame;
//@property GameManager *gameManager;
@property NSUserDefaults *defaults;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.defaults = [NSUserDefaults standardUserDefaults];

    [[GameManager sharedManager] printCurrentGame];
//    if (![GameManager sharedManager].currentGame)
//    {
//        //TODO: decide which game to pull here (change getCurrentGameWithCompletion method) OR ask user to create or select game?
//        [Game getCurrentGameWithCompletion:^(Game *currentGame) {
//            // Set game object to singleton
//            [GameManager sharedManager].currentGame = currentGame;
//            NSLog(@"Fetched game: %@", [GameManager sharedManager].currentGame.name);
//        }];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // If no current game exists:
    if (![self.defaults objectForKey:kGameIdKey])
    {
        //TODO: ask/tell user to select or create game
        // Tell user to create or select a game
        // Alert view to prompt user to select game???
    }
    else
    {
        // Load current game from user defaults and set to global current game
//        [Game loadSavedGame];
//        NSLog(@"Loaded game from defaults: %@", [GameManager sharedManager].currentGame);

        [Game loadSavedGameWithCompletion:^(Game *loadedGame) {
            NSLog(@"Loaded game from defaults from parse: %@", loadedGame);
        }];
    }
    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", [User currentUser].username];
    NSLog(@"GameId from NSDefaults: %@", [self.defaults objectForKey:kGameIdKey]);
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
    NSLog(@"logged in as: %@", [User currentUser].username);
    self.tabBarController.selectedIndex = 1;
}

- (void) onSignUpButtonPressed
{
    [self.loginVC performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

@end
