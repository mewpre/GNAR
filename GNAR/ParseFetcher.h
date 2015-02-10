//
//  ParseFetcher.h
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseFetcher : NSObject

+ (void)getCurrentUserGamesWithCompletion:(void(^)(NSArray *array))complete;

@end
