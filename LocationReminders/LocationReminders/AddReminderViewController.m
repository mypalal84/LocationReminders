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
- (IBAction)SaveReminderButtonPressed:(id)sender {
    Reminder *newReminder = [Reminder object];
    
    newReminder.name = self.nameTextField.text;
    
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        NSLog(@"Annotation Title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Save Reminder Successful: %i - Error: %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReminderSavedToParse" object:nil];
    }];

    
    if (self.completion){
        CGFloat radius = self.radiusSlider.value;
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
        
        //start monitoring for region
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:self.coordinate radius:radius identifier:newReminder.name];
            
            [LocationController.shared startMonitoringForRegion:region];
        }
        
        self.completion(circle);
    }
//    self.radiusSlider.value = newReminder.radius.intValue;
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)radiusSliderValueChanged:(id)sender {
    NSNumber *radiusNumber = [NSNumber numberWithInt:self.radiusSlider.value];
    self.radiusLabel.text = [NSString stringWithFormat:@"%@", radiusNumber];
    
}


@end
