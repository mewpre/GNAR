//
//  SignUpViewController.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "SignUpViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Comms.h"

@interface SignUpViewController () <CommsDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([PFUser currentUser])
    {
        NSLog(@"Already logged in as %@", [PFUser currentUser].username);
    }
}



//----------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onSignUpButtonPressed:(UIButton *)sender
{
    if ([self.usernameTextField.text isEqualToString:@""])
    {
        [self showSignUpErrorAlertController:@"Error: Username Required" withMessage:@"Please enter a username."];
    }
    else if([self.passwordTextField.text isEqualToString:@""])
    {
        [self showSignUpErrorAlertController:@"Error: Password missing" withMessage:@"Please enter a password."];
    }
    else if ([self.emailTextField.text isEqualToString:@""])
    {
        [self showSignUpErrorAlertController:@"Error: Email missing" withMessage:@"Please enter a email."];

    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 // Hooray! Let them use the app now.
                 NSLog(@"Signed up as %@", [PFUser currentUser].username);
                 [self dismissViewControllerAnimated:NO completion:nil];
             }
             else
             {
                 NSString *errorString = [error userInfo][@"error"];
                 [self showSignUpErrorAlertController:@"Error" withMessage:errorString];
             }
         }];
    }
}

- (IBAction)onFacebookButtonPressed:(UIButton *)sender
{
    if (![self.usernameTextField.text isEqualToString:@""])
    {
        // Do the signup
        [Comms signup:self withUsername:self.usernameTextField.text];
    }
    else
    {
        [self showSignUpErrorAlertController:@"Error: Username Required" withMessage:@"Please enter a username."];
    }
}

- (void) commsDidSignUp:(BOOL)signedUp
{
    // Did we signup successfully ?
    if (signedUp)
    {
        NSLog(@"Logged in with Facebook!");
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"%@", userData);
                [[PFUser currentUser] setEmail:userData[@"email"]];
                [[PFUser currentUser] setObject:userData[@"gender"] forKey:@"gender"];
                [[PFUser currentUser] saveInBackground];
                [self dismissViewControllerAnimated:NO completion:nil];

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
    [self showSignUpErrorAlertController:@"Account already created" withMessage:@"There's already a GNAR account associated with your Facebook. Logging in to your GNAR account."];
}

- (void)showSignUpErrorAlertController: (NSString *)errorTitle withMessage: (NSString*)errorMessage
{
    UIAlertController * alert= [UIAlertController
                                  alertControllerWithTitle:errorTitle
                                  message:errorMessage
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
