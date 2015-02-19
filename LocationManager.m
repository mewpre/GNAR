//
//  LocationManager.m
//  GNAR
//
//  Created by Chris Giersch on 2/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager



//- (void)getUpdatedLocationWithCompletion:(void(^)(CLLocationCoordinate2D location))complete
//{
//    [self startUpdatingLocation];
//    [self setDesiredAccuracy:kCLLocationAccuracyBest];
//
//
//}


////-------------------------------    Location Manager    ----------------------------------
//#pragma mark - Location Manager
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocationCoordinate2D myLocation = [locations.firstObject coordinate];
//    self.currentCLLocationCoordinate = myLocation;
////    [self.mapView setCenterCoordinate:self.myLocation animated:YES];
//
//    // Set phones current location
//    self.currentCLLocation = locations.lastObject;
//
//
//    if (self.currentCLLocation != nil)
//    {
//        // Stop updating location
//        [self stopUpdatingLocation];
////        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myLocation, 1000, 1000);
////        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"EROOR %@", error);
//}

















@end
