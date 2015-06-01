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
#import "User.h"
#import "School.h"
#import "ChargeCodes.h"

@interface ChargeViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *tfDescription;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;
@property (strong, nonatomic) IBOutlet UITextField *tfTotal;
@property (strong, nonatomic) IBOutlet UILabel *lbChargeDate;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnEnterCharge;
@property (strong, nonatomic) IBOutlet UIPickerView *chargeTypePicker;

@property (atomic, retain) NSMutableArray *chargeTypeArray;
@property (atomic, retain) NSMutableArray *arrayOfChargeCodes;
@property (atomic, retain) NSMutableArray *chargeAmountArray;
@property (strong, nonatomic) IBOutlet UIScrollView *enterChargeScrollView;

@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) ChargeCodes *chargeCodes;


@property int ChgID;
@property float Amount;
@property float AccountFeeAmount;
@property float STax1;
@property float STax2;
@property float totalWithTax;
@property float amountFromWebservice;
@property BOOL hasTax;
@property BOOL hasDiscount;

@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSArray *chargeCodeDiciontary;
@property (nonatomic, strong) NSArray *responseData;


@end
