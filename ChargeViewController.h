//
//  ChargeViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/6/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "Account.h"

@interface ChargeViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfDescription;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbChargeDate;
@property (strong, nonatomic) IBOutlet UIButton *btnEnterCharge;
@property (strong, nonatomic) IBOutlet UIPickerView *chargeTypePicker;
@property (atomic, retain) NSArray *chargeTypeArray;
@property (strong, nonatomic) IBOutlet UIScrollView *enterChargeScrollView;

@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) Globals *oGlobals;

@end
