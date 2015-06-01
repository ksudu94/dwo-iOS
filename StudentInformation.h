//
//  StudentInformation.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "EditStudentInformation.h"
#import "EnrollStudentViewController.h"
#import "User.h"
#import "School.h"

@interface StudentInformation : UIViewController<UITabBarControllerDelegate, EditStudentInformationDelegate, EnrollStudentViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *txtStudentAddress;
@property (strong, nonatomic) IBOutlet UILabel *txtStudentName;
@property (strong, nonatomic) IBOutlet UILabel *txtStudentPhone;
@property (strong, nonatomic) IBOutlet UILabel *txtStudentAccountName;
@property (strong, nonatomic) IBOutlet UILabel *txtStudentStatus;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, retain) Student *selectedStudent;

-(void) setStudentFields;
//@property (nonatomic, retain) EditStudentInformation *editStudentsController;

@end
