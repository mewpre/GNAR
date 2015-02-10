//
//  Comms.h
//  GNAR
//
//  Created by Yi-Chin Sun on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
- (void) commsDidSignUp:(BOOL)signedUp;
- (void)showAlertController;
@end

@interface Comms : NSObject
+ (void) login:(id<CommsDelegate>)delegate;
+ (void) signup:(id<CommsDelegate>)delegate withUsername: (NSString *)username;
@end