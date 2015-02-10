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
                        [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [PFUser logOut];
                            [delegate showAlertController];
                        }];
                    }
                    else
                    {
                        [[PFUser currentUser] saveInBackground];
                        
                        // Callback - login successful
                        if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                            [delegate commsDidLogin:YES];
                        }
                    }
                }
            }];
        }
    }];
}

+ (void) signup:(id<CommsDelegate>)delegate withUsername: (NSString *)username
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // Was signup successful ?
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook signup.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }

            // Callback - signup failed
            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:NO];
            }
        }
        else
        {
            // Callback - signup successful
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 if (!error) {
                     NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                     // Store the Facebook Id
                     [[PFUser currentUser] setObject:me.objectID forKey:@"fbId"];
                     if (user.isNew)
                     {
                         [PFUser currentUser].username = username;
                         [[PFUser currentUser] saveInBackground];

                         [delegate commsDidSignUp:YES];
                     }
                     else
                     {
                         [delegate showAlertController];
                     }
                 }
             }];
        }
    }];
}

@end
