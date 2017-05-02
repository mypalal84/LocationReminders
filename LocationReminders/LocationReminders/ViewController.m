//
//  ViewController.m
//  LocationReminders
//
//  Created by A Cahn on 5/1/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "ViewController.h"

@import Parse;
@import MapKit;

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self requestPermissions];
    self.mapView.showsUserLocation = YES;
    
    
}

-(void)requestPermissions{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100; //meters
    
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
}



- (IBAction)locationOnePressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.618217, -122.351832);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000.0, 1000.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)locationTwoPresses:(id)sender {
    CLLocationCoordinate2D coordinateTwo = CLLocationCoordinate2DMake(40.689249, -74.044500);
    
    MKCoordinateRegion regionTwo = MKCoordinateRegionMakeWithDistance(coordinateTwo, 1000.0, 1000.0);
    
    [self.mapView setRegion:regionTwo animated:YES];
}

- (IBAction)locationThreePressed:(id)sender {
    CLLocationCoordinate2D coordinateThree = CLLocationCoordinate2DMake(48.858370, 2.294481);
    
    MKCoordinateRegion regionThree = MKCoordinateRegionMakeWithDistance(coordinateThree, 1000.0, 1000.0);
    
    [self.mapView setRegion:regionThree animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = locations.lastObject;
    
    NSLog(@"Coordinate: %f, - Altitude: %f", location.coordinate.longitude, location.altitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0);
    
    [self.mapView setRegion:region animated:YES];
    
}

@end
