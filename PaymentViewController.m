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
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.oGlobals = [[Globals alloc] init];
    _tfReference.delegate = self;
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    self.typeArray = @[@"Cash", @"Check", @"Other", @"Use New Credit Card", @"Use Saved Credit Card"];
    
    
    //Two keyboard methods that scroll the view and dismiss the keyboard
    [self registerForKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    //Manually set this to the first time they leave it blank initially
    [_tfReference setText: @"Cash"];
    NSString *currentDate = [_oGlobals getTime];

    [_lbDate setText:currentDate];
    
    /**
     * These values are defined up here because they could possible change. IE if they input a new card and wish to save it on file. CardNumber will be the new credit card number and CCard will be the last 4 of the new card.
     */
    _saveCard = FALSE;
    _currentDate = [_oGlobals getTime];
    _CCard = _selectedAccount.CCTrail;
    _CCDate = _selectedAccount.CCExpire;
    _CVV = @"";
    _ChkNo = @"Cash";
    _Kind = @"$";
    
    /**
     * If they choose to input a new card, CardNumber is that new number, otherwise it is ""
     */
    if([_selectedAccount.CCTrail isEqualToString:@""])
        _CardNumber = @"";
    else
    {
        _CardNumber = [_selectedAccount.CCTrail substringFromIndex:[_selectedAccount.CCTrail length] -4];
        
    }
    
    /**
     *If they got to this screen by selecting a charge from by selecting a transaction fron the AccountTransactions page then there is a charge id, otherwise it's 0;
     */
    if(_selectedACharge)
    {
        _ChgID = _selectedAccountTransaction.TID;
        NSString *formattedAmount = [NSString stringWithFormat:@"%.2f", _selectedAccountTransaction.Amount];
        _tfAmount.text = formattedAmount;
        _tfDescription.text = _selectedAccountTransaction.TDesc;
        _tfReference.text = _selectedAccountTransaction.RefNo;

    }
    else
    {
        _ChgID = 0;
        _tfAmount.text = @"0.00";
    }
    
}

/**
 * Formatting amount textfield on the fly
 */
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString*)string
{
    //Only want that schmancy format stuff if it's a textfield w/ numbers
    if([textField isEqual:_tfAmount])
    {
        NSString* newAmount = [_oGlobals textField:textField formatAmountCharactersInRange:range replacementString:string];
        _tfAmount.text = newAmount;
    return NO;
    }
    return YES;
}

/**
 *Submitting a payment
 */
- (IBAction)enterPayment:(id)sender
{
     NSError *error = nil;
    [_btnEnterPayment setEnabled:FALSE];
    float flAmount = [_tfAmount.text floatValue];
    if([_tfReference.text isEqualToString:@""] || [_tfDescription.text isEqualToString:@""] )
    {
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error, no blank fields allowed."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_btnEnterPayment setEnabled:TRUE];

     
    }
    else if ( flAmount < 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error, payment must greater than $1.00."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_btnEnterPayment setEnabled:TRUE];

    }
    else
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        //Pull stored objects from NSUserDefaults as dictionaries
        NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
        NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
        
        NSError *e = nil;
        _User = [[User alloc] initWithDictionary:dictUser error:&e];
        _School = [[School alloc] initWithDictionary:dictSchool error:&e];
        _oGlobals = [[Globals alloc] init];
        
        //Reset this value for future
        _selectedACharge = FALSE;
        
        
        /**
         * Lots of empty strings because they may or may not be required for other Processors ie PowerPay or Mercury.
         * For example PaymentID to CarHolderName are all required for Mercury.
         */
        _amount = [_tfAmount.text floatValue];
        _paymentDescription = _tfDescription.text;
        _StrUsername =_User.UserName;
        _CCMerch = _School.CCMerchantNo;
        _CCMaxAmount = _School.CCMaxAmt;
        _CCUser = _School.CCUserName;
        _CCPass = _School.CCPassword;
        _ConsentID = _selectedAccount.CCConsentID;
        
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        
        [params setObject:[NSString stringWithFormat:@"%d", self.User.UserID]  forKey:@"UserID"];
        [params setObject:self.User.UserGUID forKey:@"UserGUID"];
        [params setObject:[NSString stringWithFormat:@"%ld", (long)self.selectedAccount.AcctID] forKey:@"AcctID"];
        [params setObject:_currentDate forKey:@"PDate"];
        [params setObject:_paymentDescription forKey:@"PDesc"];
        [params setObject:_ChkNo forKey:@"ChkNo"];
        [params setObject:[NSString stringWithFormat:@"%.2f", _amount]  forKey:@"Amount"];
        [params setObject:_Kind forKey:@"Kind"];
        [params setObject:_CCard forKey:@"CCard"];
        [params setObject:_CCDate forKey:@"CCDate"];
        [params setObject:[NSString stringWithFormat:@"%ld", (long)_School.SessionID] forKey:@"SessionID"];
        [params setObject:[NSString stringWithFormat:@"%ld", (long)_ConsentID] forKey:@"ConsentID"];
        [params setObject:_CCUser forKey:@"ccuser"];
        [params setObject:_CCPass forKey:@"ccpass"];
        [params setObject:_CardNumber forKey:@"CardNumber"];
        [params setObject:_StrUsername forKey:@"strUsername"];
        [params setObject:[NSString stringWithFormat:@"%d", _CCMerch] forKey:@"CCMerch"];
        [params setObject:[NSString stringWithFormat:@"%.02f", _CCMaxAmount]  forKey:@"CCMaxAmount"];
        [params setObject:_CVV forKey:@"CVV"];
        [params setObject:_selectedAccount.CCFName forKey:@"FName"];
        [params setObject:_selectedAccount.CCLName forKey:@"LName"];
        [params setObject:_selectedAccount.CCAddress forKey:@"Address"];
        [params setObject:_selectedAccount.CCCity forKey:@"City"];
        [params setObject:_selectedAccount.CCState forKey:@"State"];
        [params setObject:_selectedAccount.CCZip forKey:@"Zip"];
        [params setObject:[NSString stringWithFormat:@"%d", _saveCard] forKey:@"saveCard"];
        [params setObject:[NSString stringWithFormat:@"%ld", (long)_ChgID] forKey:@"ChgID"];
        
        
        NSMutableString *paymentMethod = [[NSMutableString alloc] init];
        [paymentMethod setString:@"enterPayment?"];
        
        NSString * url = [self.oGlobals buildURL:paymentMethod fromDictionary:params];
        
        NSURL *paymentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:paymentURL];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
        
        //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
        operation.responseSerializer = [AFCompoundResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *e = nil;
            // 3
            _responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&e];
            if([[_responseData objectAtIndex:0] isEqualToString:@"Payment succesfully entered."])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment successfully entered."
                                                                    message:[e localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was an error processing the payment. No money was charged."
                                                                    message:[e localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
            NSLog(@"JSON: %@", [_responseData objectAtIndex:0]);
            [_btnEnterPayment setEnabled:TRUE];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.description
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [_btnEnterPayment setEnabled:TRUE];

        }];
        
        // 5
        [operation start];
    }

 

}

/**
 *Choosing enter new credit for the payment option. Brings up modal view
*/
-(void) enterNewCreditCard
{
    ModalCreditCard *enterNewCard = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EnterNewCreditCard"];
    enterNewCard.paymentController = self;
    enterNewCard.CardNumber = @"12345";
    enterNewCard.providesPresentationContextTransitionStyle = YES;
    enterNewCard.definesPresentationContext = YES;
    [enterNewCard setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController pushViewController:enterNewCard animated: YES];
    
    NSString *firstCharacter = [_CardNumber substringToIndex:1];
    int firstDigit = [firstCharacter integerValue];
    switch (firstDigit)
    {
        case 3:
            _ChkNo = @"AmEx";
            _Kind = @"A";
            break;
        case 4:
            _ChkNo = @"Visa";
            _Kind = @"V";
            break;
        case 5:
            _ChkNo = @"MC";
            _Kind = @"M";
            break;
        case 6:
            _ChkNo = @"Discover";
            _Kind = @"D";
            break;
        default:
            break;
    }
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
        case 0:
            strReference = @"Cash";
            _ChkNo = @"Cash";
            _Kind = @"$";
            break;
        case 1:
            strReference = @"Chk";
            _ChkNo = @"Chk";
            _Kind = @"C";
            break;
        case 2:
            strReference = @"Other";
            _ChkNo = @"Other";
            _Kind = @"O";
            break;
        case 3:
            [self enterNewCreditCard];
        case 4:
            switch (_selectedAccount.CCType) {
                case 1:
                    strReference = @"AmEx";
                    _ChkNo = @"AmEx";
                    _Kind = @"A";
                    break;
                case 2:
                    strReference = @"Discover";
                    _ChkNo = @"Discover";
                    _Kind = @"D";
                    break;
                case 3:
                    strReference = @"MC";
                    _ChkNo = @"MC";
                    _Kind = @"M";
                    break;
                case 4:
                    strReference = @"Visa";
                    _ChkNo = @"Visa";
                    _Kind = @"V";
                    break;
            }
            break;
            
        default:
            strReference = @"";
            break;
    }
    [_tfReference setText:strReference];
    
}


- (void) textFieldChanged:(UITextField *) textField
{
    [self setReferenceText];
}

//Dismiss keyboard on enter click
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Call this method somewhere in your view controller setup code. Allows scrollview to move so that keyboard doesn't cover
// up text field.
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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = kbSize;
        kbSize.height = origKeySize.width;
        kbSize.width = origKeySize.height;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    _enterPaymentScrollView.contentInset = contentInsets;
    _enterPaymentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _enterPaymentScrollView.contentInset = contentInsets;
    _enterPaymentScrollView.scrollIndicatorInsets = contentInsets;
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
