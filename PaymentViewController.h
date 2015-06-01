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
#import "User.h"
#import "School.h"
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

@property (nonatomic, strong) NSArray *responseData;

@property BOOL selectedACharge;
@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) School *School;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) AccountTransactions *selectedAccountTransaction;

//These are used for formatting the amount textfield automatically
@property (strong, nonatomic) NSString* decimalSeparator;
@property (assign, nonatomic) int maximumFractionDigits;

@property(atomic, strong) NSString* ModalCardNumber;
@property(atomic, strong) NSString* ModalCardCVV;
@property(atomic, strong) NSString* ModalCardExpire;

@property(atomic, strong) NSString* CardDate;
@property(atomic, strong) NSString* currentDate;
@property(atomic, strong) NSString* paymentDescription;
@property(atomic, strong) NSString* ChkNo;
@property float amount;
@property(atomic, strong) NSString* Kind;
@property(atomic, strong) NSString* CCard;
@property(atomic, strong) NSString* CCDate;
@property int ConsentID;
@property(atomic, strong) NSString* CCUser;
@property(atomic, strong) NSString* CCPass;
@property(atomic, strong) NSString* CardNumber;
@property(atomic, strong) NSString* StrUsername;
@property int CCMerch;
@property float CCMaxAmount;
@property(atomic, strong) NSString* CVV;
@property BOOL saveCard;
@property int ChgID;
- (void) textFieldChanged:(UITextField *) textField;

@end

