  //
//  IsLoggedIn.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/20/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "IsLoggedIn.h"

@implementation IsLoggedIn

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int UserID = [defaults integerForKey:@"UserID"];
    if(UserID > 0)
    {
        [self performSegueWithIdentifier:@"AccountListSegue" sender:self];

    }
    else
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];

    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

@end
