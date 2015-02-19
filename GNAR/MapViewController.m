//
//  MapViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "MapViewController.h"
//#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "LocationManager.h"
#import "User.h"

@interface MapViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property LocationManager *locationManager;
//@property CLLocation *currentLocation;
//@property CLLocationCoordinate2D myLocation;
@property User *currentUser;


@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    [self setupLocationManager];

    // Update location
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }

    // Add user's location to map
    self.mapView.showsUserLocation = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.locationManager startUpdatingLocation];

}


//-----------------------------    Setup Location Manager    ----------------------------------
#pragma mark - Setup Location Manager
- (void)setupLocationManager
{
    // Pre-check for authorizations
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"location services are disabled");
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"location services are blocked by the user");
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"about to show a dialog requesting permission");
    }

    // Create LocationManager
    self.locationManager = [LocationManager new];
    self.locationManager.delegate = self;

    // Request user authorization
    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startMonitoringSignificantLocationChanges];

    /* Pinpoint our location with the following accuracy:
     *
     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
     *     kCLLocationAccuracyBest               highest
     *     kCLLocationAccuracyNearestTenMeters   10 meters
     *     kCLLocationAccuracyHundredMeters      100 meters
     *     kCLLocationAccuracyKilometer          1000 meters
     *     kCLLocationAccuracyThreeKilometers    3000 meters
     */
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    /* Notify changes when device has moved x meters.
     * Default value is kCLDistanceFilterNone: all movements are reported.
     */
    self.locationManager.distanceFilter = 10.0f;

    /* Notify heading changes when heading is > 5.
     * Default value is kCLHeadingFilterNone: all movements are reported.
     */
    self.locationManager.headingFilter = 5;
}

//--------------------------------------    Location Manager    ---------------------------------------------
#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocationCoordinate2D myLocation = [locations.firstObject coordinate];
//    self.myLocation = myLocation;
    self.locationManager.currentCLLocationCoordinate = myLocation;
//    [self.mapView setCenterCoordinate:self.myLocation animated:YES];

    // Set phones current location
    self.locationManager.currentCLLocation = locations.lastObject;

    if (self.locationManager.currentCLLocation != nil)
    {
        // Stop updating location
        [self.locationManager stopUpdatingLocation];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.currentCLLocationCoordinate, 1000, 1000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.locationManager.currentCLLocationCoordinate.latitude longitude:self.locationManager.currentCLLocationCoordinate.longitude];
        [[PFUser currentUser] setObject:geoPoint forKey:@"lastKnownLocation"];
        [self.currentUser saveInBackground];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"User has denied location services");
    }
    else
    {
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end