//
//  LocationManager.h
//  GNAR
//
//  Created by Chris Giersch on 2/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : CLLocationManager  //<CLLocationManagerDelegate>

@property CLLocation *currentCLLocation;
@property CLLocationCoordinate2D currentCLLocationCoordinate;

@end
