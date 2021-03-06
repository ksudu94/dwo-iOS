//
//  EditCreditCardInformation.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 2/27/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "Globals.h"
#import "User.h"
#import "School.h"

@class EditCreditCardInformation;

@protocol EditCreditCardControllerDelegate <NSObject>
-(void) addItemViewController: (EditCreditCardInformation *) controller didFinishEnteringItem: (Account *) editedAccount;
@end

@interface EditCreditCardInformation : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id <EditCreditCardControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *tfFname;
@property (strong, nonatomic) IBOutlet UITextField *tfLame;
@property (strong, nonatomic) IBOutlet UITextField *tfCC;
@property (strong, nonatomic) IBOutlet UITextField *tfExpDate;
@property (strong, nonatomic) IBOutlet UITextField *tfAddress;
@property (strong, nonatomic) IBOutlet UITextField *tfCity;
@property (strong, nonatomic) IBOutlet UITextField *tfState;
@property (strong, nonatomic) IBOutlet UITextField *tfZip;
@property (strong, nonatomic) IBOutlet UIScrollView *editCreditCardScrollView;

@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) School *selectedSchool;

@property (nonatomic, strong) Globals *oGlobals;

-(void) saveCreditCardInformation;
@end

