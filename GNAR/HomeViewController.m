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

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property LoginViewController *loginVC;
//@property Game *currentGame;
//@property GameManager *gameManager;
@property NSUserDefaults *defaults;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    // Create achievements for testing
//    Achievement *ML = [Achievement new];
//    ML[@"name"] = @"Freebird";
//    ML[@"descriptionString"] = @"";
//    ML[@"type"] = @0;
//    ML[@"group"] = @"Eagle's Nest";
//    [ML saveInBackground];
//    NSLog(@"Saved achievements");

    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    // Associate the device with a user
//    [PFInstallation currentInstallation][@"user"] = [User currentUser];
//    [[PFInstallation currentInstallation] saveInBackground];

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
//        [Game loadSavedGame];
//        NSLog(@"Loaded game from defaults: %@", [GameManager sharedManager].currentGame);

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

////-----------------------------    Setup Location Manager    ----------------------------------
//#pragma mark - Setup Location Manager
//- (void)setupLocationManager
//{
//    // Pre-check for authorizations
//    if (![CLLocationManager locationServicesEnabled])
//    {
//        NSLog(@"location services are disabled");
//        return;
//    }
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        NSLog(@"location services are blocked by the user");
//        return;
//    }
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
//    {
//        NSLog(@"about to show a dialog requesting permission");
//    }
//
//    // Create LocationManager
//    self.locationManager = [CLLocationManager new];
//    self.locationManager.delegate = self;
//
//    // Request user authorization
//    [self.locationManager requestAlwaysAuthorization];
//    //    [self.locationManager startMonitoringSignificantLocationChanges];
//
//    /* Pinpoint our location with the following accuracy:
//     *
//     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
//     *     kCLLocationAccuracyBest               highest
//     *     kCLLocationAccuracyNearestTenMeters   10 meters
//     *     kCLLocationAccuracyHundredMeters      100 meters
//     *     kCLLocationAccuracyKilometer          1000 meters
//     *     kCLLocationAccuracyThreeKilometers    3000 meters
//     */
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//
//    /* Notify changes when device has moved x meters.
//     * Default value is kCLDistanceFilterNone: all movements are reported.
//     */
//    self.locationManager.distanceFilter = 10.0f;
//
//    /* Notify heading changes when heading is > 5.
//     * Default value is kCLHeadingFilterNone: all movements are reported.
//     */
//    self.locationManager.headingFilter = 5;
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        NSLog(@"User has denied location services");
//    }
//    else
//    {
//        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
//    }
//}


@end
