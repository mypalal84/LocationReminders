//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by A Cahn on 5/2/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"

#import "LocationController.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)SaveReminderButtonPressed:(id)sender {
    Reminder *newReminder = [Reminder object];
    
    newReminder.name = self.nameTextField.text;
    
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    NSNumber *radius = [NSNumber numberWithFloat:self.radiusSlider.value];
    
    newReminder.radius = radius;
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Annotation Title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Save Reminder Successful: %i - Error: %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse" object:nil];
    }];
    
        //start monitoring for region
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:self.coordinate radius:radius.doubleValue identifier:newReminder.name];
            
            [LocationController.shared startMonitoringForRegion:region];

    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)radiusSliderValueChanged:(id)sender {
    NSNumber *radiusNumber = [NSNumber numberWithInt:self.radiusSlider.value];
    self.radiusLabel.text = [NSString stringWithFormat:@"%@", radiusNumber];
    
}


@end
