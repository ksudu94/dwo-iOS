//
//  StudentViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "User.h"
#import "School.h"
#import "Globals.h"
#import "StudentInformation.h"

@interface StudentViewController : UITableViewController

@property (atomic, retain) Student *selectedStudent;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, strong) Student *Student;
@property (nonatomic, strong) Globals *oGlobal;

@property (nonatomic, retain) UITabBarController *studentTabBarController;
@property (nonatomic, retain) StudentInformation *studentInformationController;

@property (nonatomic, retain) UIBarButtonItem *rightBarButton;
@property (nonatomic, retain) UIBarButtonItem *leftBarButton;


@property (nonatomic, strong) NSMutableArray *studentsObjects;
@property (nonatomic, strong) NSMutableData *_receivedData;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDictionary *data;

-(void)LogOut: (id)sender;

@end
