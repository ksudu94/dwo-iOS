//
//  LoginController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/27/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"
#import "School.h"
#import "User.h"

@interface LoginController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISwitch *switchRememberMe;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (nonatomic, strong) NSMutableArray *UserArray;
@property (nonatomic, strong) NSMutableArray *SchoolArray;

@property (nonatomic, strong) Globals *oGlobal;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) School *objSchool;
@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) TWTMenuViewController *menuViewController;
@property (nonatomic, strong) TWTMainViewController *mainViewController;

-(IBAction)textFieldReturn:(id)sender;

- (IBAction)btnLogin:(id)sender;

@end
