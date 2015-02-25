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
#import "User.h"

@interface SignUpViewController () <CommsDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *skierBoarderSegControl;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *broChickSegControl;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpViewController

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
    [self.emailTextField resignFirstResponder];
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
        [self showSignUpErrorAlertController:@"Error: Email missing" withMessage:@"Please enter an email."];
    }
    else if ([self.skierBoarderSegControl selectedSegmentIndex] != 0 && [self.skierBoarderSegControl selectedSegmentIndex] != 1)
    {
        [self showSignUpErrorAlertController:@"Error: No riding style selected" withMessage:@"Please select whether you're a skier or a boarder."];
    }
    else if ([self.broChickSegControl selectedSegmentIndex] != 0 && [self.broChickSegControl selectedSegmentIndex] != 1)
    {
        [self showSignUpErrorAlertController:@"Error: No gender selected" withMessage:@"Please select whether you're a bro or a chick."];
    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        if ([self.broChickSegControl selectedSegmentIndex] == 0)
        {
            [user setObject:@"male" forKey:@"gender"];
            UIImage *image = [UIImage imageNamed:@"male"];
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            PFFile *file = [PFFile fileWithName:@"maleAvatar.png" data:imageData];
            [user setObject:file forKey:@"profileImage"];

        }
        else
        {
            [user setObject:@"female" forKey:@"gender"];
            UIImage *image = [UIImage imageNamed:@"female"];
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            PFFile *file = [PFFile fileWithName:@"femaleAvatar.png" data:imageData];
            [user setObject:file forKey:@"profileImage"];
        }

        if ([self.skierBoarderSegControl selectedSegmentIndex] == 0)
        {
            [user setObject:@"skier" forKey:@"type"];
        }
        else
        {
            [user setObject:@"snowboarder" forKey:@"type"];
        }

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 // Hooray! Let them use the app now.
                 NSLog(@"Signed up as %@", [User currentUser].username);
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
    if ([self.usernameTextField.text isEqualToString:@""])
    {
        [self showSignUpErrorAlertController:@"Error: Username Required" withMessage:@"Please enter a username."];
    }
//    else if (![self.skierBoarderSegControl isSelected])
//    {
//        [self showSignUpErrorAlertController:@"Error: No riding style selected" withMessage:@"Please select whether you're a skier or a snowboarder."];
//    }
    else
    {
        // Do the signup
        [Comms signup:self withUsername:self.usernameTextField.text];
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
                [[User currentUser] setEmail:userData[@"email"]];
                [[User currentUser] setObject:userData[@"gender"] forKey:@"gender"];
                if ([self.skierBoarderSegControl selectedSegmentIndex] == 0)
                {
                    [[User currentUser] setObject:@"skier" forKey:@"type"];
                }
                else
                {
                    [[User currentUser] setObject:@"snowboarder" forKey:@"type"];
                }
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", userData[@"id"]]];

                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

                // Run network request asynchronously
                [NSURLConnection sendAsynchronousRequest:urlRequest
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:
                 ^(NSURLResponse *response, NSData *data, NSError *connectionError)
                 {
                     if (connectionError == nil && data != nil)
                     {
                         PFFile *file = [PFFile fileWithName:@"profilePic.jpg" data:data];
                         [[User currentUser] setObject:file forKey:@"profileImage"];
                         [[User currentUser] saveInBackground];
                     }
                 }];
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
