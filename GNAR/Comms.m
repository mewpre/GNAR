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
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }

            // Callback - login successful
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
            {
                if (!error) {
                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                    // Store the Facebook Id
                    [[PFUser currentUser] setObject:me.objectID forKey:@"fbId"];
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

@end
