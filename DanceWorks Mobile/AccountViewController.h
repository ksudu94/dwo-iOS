//
//  AccountViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "User.h"
#import "School.h"
#import "Globals.h"
#import "AccountInformation.h"

@interface AccountViewController : UITableViewController

@property (nonatomic, strong) Globals *oGlobal;
@property (atomic, retain) School *objSchool;
@property (atomic, retain) Account *objAccount;
@property (atomic, retain) User *objUser;
@property (atomic, retain) Account *selectedAccount;

@property (nonatomic, retain) UIBarButtonItem *rightBarButton;
@property (nonatomic, retain) UIBarButtonItem *leftBarButton;

@property (nonatomic, retain) UITabBarController *accountTabBarController;
@property (nonatomic, retain) AccountInformation *accountInformationController;


@property (nonatomic, strong) NSDictionary *accountsDictionary;
@property (nonatomic, strong) NSMutableArray *accountsObjects;
@property (nonatomic, strong) NSMutableData *_receivedData;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;



-(void)LogOut: (id)sender;
@end

