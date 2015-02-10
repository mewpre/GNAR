//
//  Comms.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Comms.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation Comms

+ (void) login:(id<CommsDelegate>)delegate
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // Was login successful ?
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }

            // Callback - login failed
            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:NO];
            }
        }
        else
        {
            // Callback - login successful
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
            {
                if (!error) {
                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                    // Store the Facebook Id
                    [[PFUser currentUser] setObject:me.objectID forKey:@"fbId"];
                    if (user.isNew)
                    {
                        //Alert view to set username
                    }
                    [[PFUser currentUser] saveInBackground];
                }

                // Callback - login successful
                if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                    [delegate commsDidLogin:YES];
                }

            }];
        }
    }];
}

- (void)showUsernameAlertController
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Create an account?"
                                  message:@"It looks like you are trying to log in with Facebook, but there's no GNAR account associated with your Facebook Account. If you want to create a new account, please input a username you'd like to use."
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here

                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
    }];

//    [self presentViewController:alert animated:YES completion:nil];
}

@end
