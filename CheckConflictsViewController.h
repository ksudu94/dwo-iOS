//
//  CheckConflictsViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 6/1/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "User.h"
#import "School.h"
#import "Globals.h"
#import "Session.h"
#import "SchoolClasses.h"
@interface CheckConflictsViewController : UIViewController

@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, retain) Student *selectedStudent;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) SchoolClasses *selectedClass;
@property (nonatomic, strong) Globals *oGlobals;

@end
