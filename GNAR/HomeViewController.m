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

#import "Achievement.h"


@interface HomeViewController ()<LoginViewControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentGameLabel;
@property LoginViewController *loginVC;
@property Game *currentGame;
@property GameManager *gameManager;
@property NSUserDefaults *defaults;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Associate the device with a user
    [PFInstallation currentInstallation][@"user"] = [User currentUser];
    [[PFInstallation currentInstallation] saveInBackground];

    // If no current game exists:
    if (![self.defaults objectForKey:kGameIdKey])
    {
        // Tell user to create or select a game
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Current Game :C" message:@"You are not in a GNAR game. Please select or create a game!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            //Go to Games View controller
            self.tabBarController.selectedIndex = 1;
        }];
        
        [alert addAction:ok];

        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        // Load current game from user defaults and set to global current game
        [Game loadSavedGame];
        NSLog(@"Loaded game from defaults: %@", [GameManager sharedManager].currentGame);

        // Load saved game form Parse using GameId from NSUserDefaults
        [Game loadSavedGameWithCompletion:^(Game *loadedGame) {
            NSLog(@"Loaded game from defaults from parse: %@", loadedGame);

//            // Load game's players from Parse
//            [loadedGame getPlayersOfGameWithCompletion:^(NSArray *players) {
//                // Convert users to Player objects
//                NSMutableArray *playersArray = [NSMutableArray new];
//                for (User *user in players)
//                {
//
//                }
//                // Save players as singletons
//
//            }];
        }];
    }
    self.usernameLabel.text = [NSString stringWithFormat:@"%@", [User currentUser].username];
    self.currentGameLabel.text = [GameManager sharedManager].currentGame.name;
    NSLog(@"GameId from NSDefaults: %@", [self.defaults objectForKey:kGameIdKey]);
}


- (IBAction)onLogoutButtonPressed:(id)sender
{
    [PFUser logOut];
    NSLog(@"Logged Out");
    self.loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.loginVC.delegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    navCon.navigationBar.barTintColor = [UIColor blackColor];
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
