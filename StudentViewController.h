//
//  StudentViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"


@interface StudentViewController : UITableViewController
@property (atomic, retain) Student *selectedStudent;

@end
