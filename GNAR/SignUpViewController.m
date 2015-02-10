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
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];

}

- (IBAction)onFacebookButtonPressed:(UIButton *)sender
{
    if (![self.usernameTextField.text isEqualToString:@""])
    {
        // Do the signup
        [Comms signup:self withUsername:self.usernameTextField.text];
    }
}

- (void) commsDidSignUp:(BOOL)signedUp
{
    // Did we login successfully ?
    if (signedUp)
    {
        NSLog(@"Logged in with Facebook!");
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSLog(@"%@", userData);
                [[PFUser currentUser] setUsername:self.usernameTextField.text];
                NSLog(@"%@",[PFUser currentUser].objectId);
                NSLog(@"%@",[PFUser currentUser].username);
                [[PFUser currentUser] saveInBackground];

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
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Account already created"
                                  message:@"There's already a GNAR account associated with your Facebook. Logging in to your GNAR account."
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
