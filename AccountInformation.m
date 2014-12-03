//
//  AccountInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "AccountInformation.h"
#import "Account.h"
#import "AccountViewController.h"


@implementation AccountInformation
{
    
}


-(void) viewDidLoad
{
    NSLog(_selectedAccount.LName);
}

- (void) getAccount:(id)sender: (id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
}

@end
