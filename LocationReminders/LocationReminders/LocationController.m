//
//  LocationController.m
//  LocationReminders
//
//  Created by A Cahn on 5/2/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "LocationController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationController () <CLLocationManagerDelegate>
@property(strong, nonatomic)CLLocationManager *locationManager;
@end

@implementation LocationController

#pragma mark Singleton Methods
+ (instancetype)shared {
    static LocationController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        [self requestPermissions];
    }
    return self;
}


-(void)requestPermissions{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100; //meters
    
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
}

- (void)updateLocation {
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = locations.lastObject;
    
    [self.delegate locationControllerUpdatedLocation:location];
}



@end
