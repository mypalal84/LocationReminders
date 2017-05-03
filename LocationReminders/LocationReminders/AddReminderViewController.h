//
//  AddReminderViewController.h
//  LocationReminders
//
//  Created by A Cahn on 5/2/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;

@interface AddReminderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;

@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;


@property(strong, nonatomic)NSString *annotationTitle;
@property(nonatomic)CLLocationCoordinate2D coordinate;

@end
