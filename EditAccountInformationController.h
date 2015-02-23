//
//  EditAccountInformationController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 2/2/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "Globals.h"
#import "User.h"

@class EditAccountInformationController;

@protocol EditAccountInformationControllerDelegate <NSObject>
-(void) addItemViewController: (EditAccountInformationController *) controller didFinishEnteringItem: (Account *) editedAccount;
@end


@interface EditAccountInformationController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <EditAccountInformationControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *tfFname;
@property (strong, nonatomic) IBOutlet UITextField *tfLame;
@property (strong, nonatomic) IBOutlet UITextField *tfAddress;
@property (strong, nonatomic) IBOutlet UITextField *tfCity;
@property (strong, nonatomic) IBOutlet UITextField *tfState;
@property (strong, nonatomic) IBOutlet UITextField *tfZipCode;
@property (strong, nonatomic) IBOutlet UITextField *tfPhone;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UIPickerView *statusPicker;


@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) Globals *oGlobals;
@property(atomic, strong) NSString* strStatus;

@property (atomic, retain) NSArray *statusArray;
@end
