//
//  LocationController.h
//  LocationReminders
//
//  Created by A Cahn on 5/2/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddReminderViewController.h"

@protocol LocationControllerDelegate <NSObject>
@required
-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject


+ (instancetype)shared;
- (void)updateLocation;
-(void)startMonitoringForRegion:(CLRegion *)region;

@property(strong, nonatomic)CLLocation *location;
@property(weak, nonatomic)id<LocationControllerDelegate> delegate;

@end
