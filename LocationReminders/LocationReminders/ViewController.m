//
//  ViewController.m
//  LocationReminders
//
//  Created by A Cahn on 5/1/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderViewController.h"
#import "LocationController.h"
#import "Reminder.h"

@import ParseUI;

@import Parse;
@import MapKit;


@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LocationController shared].delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    self.mapView.delegate = self;
    
    [[LocationController shared] updateLocation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
    [PFUser logOut];
    
    if(![PFUser currentUser]){
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        
        loginViewController.fields = PFLogInFieldsDefault;
        
        loginViewController.logInView.logo = [[UIView alloc]init];
        
        loginViewController.logInView.backgroundColor = [UIColor grayColor];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showAllOverlays];
}

-(void)showAllOverlays{
    [self.mapView removeOverlays:self.mapView.overlays];
    
    PFQuery *query = [Reminder query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error){
            for (Reminder *reminder in objects) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:[reminder.radius intValue]];
                [self dropPin:coordinate];
                [self.mapView addOverlay:circle];
            }
        }
    }];
}

-(void)reminderSavedToParse:(id)sender{
    PFQuery *query = [Reminder query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error){
            for (Reminder *reminder in objects) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude);
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:[reminder.radius intValue]];
                [self.mapView addOverlay:circle];
                NSLog(@"Name: %@, Latitude: %f, Longitude: %f, Radius: %@",
                reminder.name,
                reminder.location.latitude,
                reminder.location.longitude,
                reminder.radius);
            }
        }
    }];
}

-(void)locationControllerUpdatedLocation:(CLLocation *)location{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    
    [self.mapView setRegion:region animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
        
        //make weak to prevent retain cycle when referencing self in a block
        __weak typeof (self) bruce = self;
        
        newReminderViewController.completion = ^(MKCircle *circle) {
            
            //makes hulk self
            __strong typeof (bruce) hulk = bruce;
            
            [hulk.mapView removeAnnotation:annotationView.annotation];
            [hulk.mapView addOverlay:circle];
        };
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderSavedToParse" object:nil];
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

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint
                                                  toCoordinateFromView:self.mapView];
        [self dropPin:coordinate];
    
    }
}

- (void)dropPin:(CLLocationCoordinate2D)coordinate{
    
    MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
    
    newPoint.coordinate = coordinate;
    newPoint.title = @"New Location";
    
    [self.mapView addAnnotation:newPoint];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; //callout button
    
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    NSLog(@"Accessory Tapped!");
    
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    
    renderer.strokeColor = [UIColor blueColor];
    renderer.fillColor = [UIColor redColor];
    renderer.alpha = 0.25;
    
    return renderer;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
