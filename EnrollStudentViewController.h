//
//  EnrollStudentViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/27/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "User.h"
#import "School.h"
#import "DownPicker.h"
#import "Globals.h"
#import "Session.h"
#import "SchoolClasses.h"
#import "ClassCell.h"

@class EnrollStudentViewController;

@protocol EnrollStudentViewControllerDelegate <NSObject>
-(void) addItemViewController: (EnrollStudentViewController *) controller didFinishEnteringItem: (Student *) editedStudent;
@end

@interface EnrollStudentViewController : UIViewController < UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <EnrollStudentViewControllerDelegate> delegate;

@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, retain) Student *selectedStudent;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) ClassCell *selectedClassCell;

@property (nonatomic, strong) SchoolClasses *selectedClass;
@property (nonatomic, strong) Globals *oGlobals;

@property (strong, nonatomic) DownPicker *downPicker;

@property (weak, nonatomic) IBOutlet UITableView *enrollClassTable;
@property (weak, nonatomic) IBOutlet UITextField *tfSession;

@property (atomic, retain) NSMutableArray *sessionNameArray;

@property (nonatomic, strong) NSMutableArray *sessionObjects;
@property (nonatomic, strong) NSMutableArray *classesObjects;

@property (nonatomic, strong) NSDictionary *classesDictionaries;
@property (nonatomic, strong) NSDictionary *sessionDictionaries;

@property (nonatomic, strong) NSDictionary *conflictsDictionary;

@end
