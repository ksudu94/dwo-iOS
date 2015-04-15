//
//  StudentInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "StudentInformation.h"
#import "Student.h"
#import "StudentViewController.h"

@implementation StudentInformation
{
    
    IBOutlet UILabel *txtStudentAddress;
    IBOutlet UILabel *txtStudentName;
    IBOutlet UILabel *txtStudentPhone;
    IBOutlet UILabel *txtStudentAccountName;
    IBOutlet UILabel *txtStudentStatus;

}

-(void) viewDidLoad
{
    [super viewDidLoad];
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",self.selectedStudent.FName,@" ",self.selectedStudent.LName];

    txtStudentName.text = fullName;
    
    txtStudentPhone.text = self.selectedStudent.Phone;
    txtStudentAddress.text = self.selectedStudent.Address;
    txtStudentAccountName.text = self.selectedStudent.AcctName;
    switch (self.selectedStudent.Status)
    
    {
        case 0:
            txtStudentStatus.text = @"Active";
            break;
        case 1:
            txtStudentStatus.text = @"Inactive";
            break;
        case 2:
            txtStudentStatus.text = @"Prospect";
            break;
        case 3:
            txtStudentStatus.text = @"Deleted";
            break;
        default:
            txtStudentStatus.text = @"Error";
            break;
    }

}

@end
