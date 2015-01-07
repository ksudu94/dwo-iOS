//
//  AccountStudentController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/5/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "School.h"
#import "User.h"
#import "Globals.h"
#import "Student.h"

@interface AccountStudentController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>


@property (atomic, retain) Account *selectedAccount;
@property (weak, nonatomic) IBOutlet UITabBar *accountTabBar;
@property (weak, nonatomic) IBOutlet UITableView *accountStudentTable;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, strong) Student *Student;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) NSMutableArray *studentsObject;

@end
