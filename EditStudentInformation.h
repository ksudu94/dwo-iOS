//
//  EditStudentInformation.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/14/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Globals.h"
#import "User.h"


@class EditStudentInformation;

@protocol EditStudentInformationDelegate <NSObject>
-(void) addItemViewController: (EditStudentInformation *) controller didFinishEnteringItem: (Student *) editedStudent;
@end

@interface EditStudentInformation : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <EditStudentInformationDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *tfFname;
@property (strong, nonatomic) IBOutlet UITextField *tfLame;
@property (strong, nonatomic) IBOutlet UITextField *tfAddress;
@property (strong, nonatomic) IBOutlet UITextField *tfCity;
@property (strong, nonatomic) IBOutlet UITextField *tfState;
@property (strong, nonatomic) IBOutlet UITextField *tfZipCode;
@property (strong, nonatomic) IBOutlet UITextField *tfPhone;
@property (strong, nonatomic) IBOutlet UITextField *tfAccountName;
@property (strong, nonatomic) IBOutlet UIPickerView *statusPicker;
@property (strong, nonatomic) IBOutlet UIScrollView *editStudentScrollView;

@property (nonatomic, retain) Student *selectedStudent;
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) Globals *oGlobals;

@property(atomic, strong) NSString* strStatus;
@property (atomic, retain) NSArray *statusArray;
@end

