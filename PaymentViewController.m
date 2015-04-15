//
//  PaymentViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/6/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "AccountInformation.h"
#import "PaymentViewController.h"
#import "ChargeViewController.h"
#import "AccountTransactionsController.h"
#import "AccountStudentController.h"
#import "ModalCreditCard.h"


@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.oGlobals = [[Globals alloc] init];
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    self.typeArray = @[@"Select A Charge Type",@"Cash", @"Check", @"Other", @"Use New Credit Card", @"Use Saved Credit Card"];
    
    NSString *currentDate = [_oGlobals getTime];
    
    [_lbDate setText:currentDate];
    [self registerForKeyboardNotifications];
    NSLog(_selectedAccount.FName);
    NSLog(_selectedAccountTransaction.TDesc);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * Updating Reference textfield after pickerview selection
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setReferenceText];
}

-(void) setReferenceText
{
    NSString *strReference = @"";
    switch ([self.typePicker selectedRowInComponent:0])
    {
        case 1:
            strReference = @"Cash";
            break;
        case 2:
            strReference = @"Chk";
            break;
        case 3:
            strReference = @"Other";
            break;
        case 4:
            [self enterNewCreditCard];
            break;
        case 5:
            switch (_selectedAccount.CCType) {
                case 1:
                    strReference = @"AmEx";
                    break;
                case 2:
                    strReference = @"Discover";
                    break;
                case 3:
                    strReference = @"MC";
                    break;
                case 4:
                    strReference = @"Visa";
                    break;
            }
            break;
        default:
            strReference = @"";
            break;
    }
    [_tfReference setText:strReference];
    //[_tfDescription setNeedsDisplay];

}

- (void) textFieldChanged:(UITextField *) textField
{
    [self setReferenceText];
}

/**
 *Choosing enter new credit for the payment option
 */
-(void) enterNewCreditCard
{
    ModalCreditCard *enterNewCard = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EnterNewCreditCard"];
    enterNewCard.providesPresentationContextTransitionStyle = YES;
    enterNewCard.definesPresentationContext = YES;
    [enterNewCard setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self performSegueWithIdentifier:@"NewCreditCardSegue" sender:self];
}

/**
 * Handling PickerView Stuff
 */
-(int) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _typeArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _typeArray[row];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.enterPaymentScrollView.contentInset = contentInsets;
    self.enterPaymentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.enterPaymentScrollView.contentInset = contentInsets;
    self.enterPaymentScrollView.scrollIndicatorInsets = contentInsets;
}

/**
 * Pass around the Account object
 */
-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[AccountInformation class]])
    {
        AccountInformation *informationController = (AccountInformation *) viewController;
        informationController.selectedAccount = self.selectedAccount;
    }
    else if([viewController isKindOfClass:[AccountStudentController class]])
    {
        AccountStudentController *studentController = (AccountStudentController *) viewController;
        studentController.selectedAccount = self.selectedAccount;
    }
    else if([viewController isKindOfClass:[AccountTransactionsController class]])
    {
        AccountTransactionsController *transactionsController = (AccountTransactionsController *) viewController;
        transactionsController.selectedAccount = self.selectedAccount;
        
    }
    else if([viewController isKindOfClass:[PaymentViewController class]])
    {
        PaymentViewController *paymentController = (PaymentViewController *) viewController;
        paymentController.selectedAccount = self.selectedAccount;
        
    }
    else if([viewController isKindOfClass:[ChargeViewController class]])
    {
        ChargeViewController *chargeController = (ChargeViewController *) viewController;
        chargeController.selectedAccount = self.selectedAccount;
        
    }
    
    return TRUE;
}

@end
