//
//  StudentClassesController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/5/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.

#import "Student.h"
#import "User.h"
#import "School.h"
#import "Globals.h"
#import "Session.h"
#import "StudentClasses.h"
#import "DownPicker.h"

@interface StudentClassesController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(atomic, strong) NSString* strSession;
@property (atomic, retain) NSMutableArray *sessionNameArray;
@property (atomic, retain) Student *selectedStudent;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) Session *Session;
@property (nonatomic, strong) Session *selectedSession;
@property (nonatomic, strong) StudentClasses *selectedClass;

@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITableView *stuClassTable;
@property (weak, nonatomic) IBOutlet UITextField *tfSession;

@property (nonatomic, strong) NSMutableArray *sessionObjects;
@property (nonatomic, strong) NSMutableArray *classesObjects;

@property (nonatomic, strong) NSMutableArray *sessionMenuItems;

@property (nonatomic, strong) NSDictionary *sessionDictionaries;
@property (nonatomic, strong) NSDictionary *classesDictionaries;


@end
