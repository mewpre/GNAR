//
//  LoginViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Comms.h"
#import "User.h"

@interface LoginViewController () <CommsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([User currentUser])
    {
        NSLog(@"Already logged in as %@", [User currentUser].username);

    }

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)hideKeyboard
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

//----------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onLoginButtonPressed:(UIButton *)sender
{
    if ([self.usernameTextField.text isEqualToString:@""])
    {
        [self showLoginErrorAlertController: @"Error: Username missing" withMessage:@"Please enter a username."];
    }
    else if([self.passwordTextField.text isEqualToString:@""])
    {
        [self showLoginErrorAlertController: @"Error: Password missing" withMessage:@"Please enter a password."];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"Logged in as %@", [User currentUser].username);
                 [self.delegate didDismissPresentedViewController];
                 self.tabBarController.selectedIndex = 2;
                 // Clear all local cached data
                 [PFQuery clearAllCachedResults];
             }
             else
             {
                 NSString *errorString = [error userInfo][@"error"];
                 NSLog(@"%@", errorString);
                 [self showLoginErrorAlertController:@"Error" withMessage:errorString];
             }
         }];
    }
}

- (IBAction)onFacebookButtonPressed:(UIButton *)sender
{
    // Do the login
    [Comms login:self];
}

- (void) commsDidLogin:(BOOL)loggedIn
{
    // Did we login successfully ?
    if (loggedIn)
    {
        NSLog(@"Logged in with Facebook!");
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"%@", userData);
                NSLog(@"%@",[User currentUser].username);
                [self.delegate didDismissPresentedViewController];
            }
        }];
    }
    else
    {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

- (void)showAlertController
{
    [self showLoginErrorAlertController:@"Account not found" withMessage:@"There's no GNAR account associated with your Facebook. Please sign up first."];
}

- (void)showLoginErrorAlertController: (NSString *)errorTitle withMessage: (NSString*)errorMessage
{
    UIAlertController *alert= [UIAlertController
                                alertControllerWithTitle:errorTitle
                                message:errorMessage
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}


@end
