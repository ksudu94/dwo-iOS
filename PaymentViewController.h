//
//  PaymentViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/6/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "Account.h"
#import "AccountTransactions.h"

@class PaymentViewController;
@protocol PaymentViewControllerDelegate <NSObject>
@end


@interface PaymentViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <PaymentViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *tfReference;
@property (strong, nonatomic) IBOutlet UITextField *tfDescription;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UIButton *btnEnterPayment;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (atomic, retain) NSArray *typeArray;
@property (strong, nonatomic) IBOutlet UIScrollView *enterPaymentScrollView;

@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) AccountTransactions *selectedAccountTransaction;


@property(atomic, strong) NSString* CardNumber;
@property(atomic, strong) NSString* CardCVV;
@property(atomic, strong) NSString* CardDate;
- (void) textFieldChanged:(UITextField *) textField;

@end

