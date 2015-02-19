//
//  MapViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MapViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create LocationManager
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    // Request user authorization (add "NSLocationWhenInUseUsageDescription" in info.plist)
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

//-------------------------------    Location Manager    ----------------------------------
#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Set phones current location
    self.currentLocation = locations.lastObject;
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
