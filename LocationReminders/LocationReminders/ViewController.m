//
//  ViewController.m
//  LocationReminders
//
//  Created by A Cahn on 5/1/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "ViewController.h"

@import Parse;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    
//    testObject[@"testName"] = @"Alex Cahn";
//    
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if succeeded {
//            NSLog(@"success saving test object");
//        } else {
//            NSLog(@"there was a problem saving. Save Error: %@", error.localizedDescription);
//        }
//    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"query results %@", objects);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
