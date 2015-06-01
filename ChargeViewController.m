//
//  ChargeViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/6/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "ChargeViewController.h"
#import "PaymentViewController.h"
#import "AccountTransactionsController.h"
#import "AccountStudentController.h"
#import "AccountInformation.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"
#import "ChargeCodes.h"

@interface ChargeViewController ()

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
    
    NSError *e = nil;
    _User = [[User alloc] initWithDictionary:dictUser error:&e];
    _School = [[School alloc] initWithDictionary:dictSchool error:&e];
    _oGlobals = [[Globals alloc] init];
    
    //This needed to be initialized before I could add the charge codes to it.
    _chargeTypeArray = [NSMutableArray array];
    _chargeAmountArray = [NSMutableArray array];
    _arrayOfChargeCodes = [NSMutableArray array];
    
 
    _chargeTypePicker.dataSource = self;
    _chargeTypePicker.delegate = self;
 
    [self getChargeCodes];

    _tfAmount.text = @"0.00";
    _tfTotal.text = @"0.00";
    
    [_tfAmount setEnabled:FALSE];
    [_tfTotal setEnabled:FALSE];
    _hasTax = FALSE;
    _hasDiscount = FALSE;
    
    NSString *currentDate = [_oGlobals getTime];
    [_lbChargeDate setText:currentDate];
    
    [self registerForKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    // Do any additional setup after loading the view.
    
    
    
}

-(void) getChargeCodes
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSString *whereString = [NSString stringWithFormat:@" where schid=%ld", (long)_School.SchID];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.User.UserID]  forKey:@"UserID"];
    [params setObject:self.User.UserGUID forKey:@"UserGUID"];
    [params setObject:whereString forKey:@"Where"];
    
    
    NSMutableString *chargeCodeMethod = [[NSMutableString alloc] init];
    [chargeCodeMethod setString:@"getChargeCodes?"];
    
    NSString * url = [self.oGlobals buildURL:chargeCodeMethod fromDictionary:params];
    
    NSURL *chargeCodeURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:chargeCodeURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    
    //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        // 3
        _chargeCodeDiciontary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&e];
        
        for (NSDictionary *dictionary in _chargeCodeDiciontary)
        {
            _chargeCodes = [[ChargeCodes alloc] initWithDictionary:dictionary error:&e];
            [_arrayOfChargeCodes addObject:_chargeCodes];
            [_chargeTypeArray addObject:_chargeCodes.ChgDesc];
        }
        //Reload the PickerView with the charge codes.
        [_chargeTypePicker reloadAllComponents];
        //Auto select first item in UIPickerview to avoid empty ChgID when there was to be one
        _chargeCodes = [_arrayOfChargeCodes objectAtIndex: 1];
        [_tfDescription setText:_chargeCodes.ChgDesc];
        _ChgID = _chargeCodes.ChgID;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was an error processing the payment. No money was charged."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
}

- (IBAction)editAmount:(id)sender
{
    
    //Default textfield to disabled, disable entering charge while editing text field
    if([_tfAmount isEnabled])
    {
        [_tfAmount setEnabled:FALSE];
        [_btnEnterCharge setEnabled:TRUE];
        [_btnEditAmount setTitle:@"Edit" forState:UIControlStateNormal];
        //I placed this in a seperate method so that I can run it both off a button click and when uipickerview is selected
        [self getAmountToCharge];

    }
    else
    {
        [_tfAmount setEnabled:TRUE];
        [_btnEnterCharge setEnabled:FALSE];
        [_btnEditAmount setTitle:@"Save" forState:UIControlStateNormal];

    }
   
    if([_tfAmount isFirstResponder])
        [_tfAmount resignFirstResponder];
    else
        [_tfAmount becomeFirstResponder];
    
}

//Calculate the total amount with tax and discounts
-(void) getAmountToCharge
{
    
    /**
     * Lots of empty strings because they may or may not be required for other Processors ie PowerPay or Mercury.
     * For example PaymentID to CarHolderName are all required for Mercury.
     */
    
    _Amount = [_tfAmount.text floatValue];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID  forKey:@"UserGUID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.selectedAccount.AcctID] forKey:@"AcctID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_ChgID] forKey:@"ChgID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_selectedAccount.BillingFreq] forKey:@"BillingFreq"];
    [params setObject:[NSString stringWithFormat:@"%.2f", _Amount]  forKey:@"Amount"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_selectedAccount.TuitionSel] forKey:@"TuitionSel"];
    [params setObject:[NSString stringWithFormat:@"%.2f", _selectedAccount.AccountFeeAmount]  forKey:@"AccountFeeAmount"];
    [params setObject:[NSString stringWithFormat:@"%@", _School.ST1Rate] forKey:@"ST1Rate"];
    [params setObject:[NSString stringWithFormat:@"%@", _School.ST2Rate] forKey:@"ST2Rate"];
    
    
    NSMutableString *paymentMethod = [[NSMutableString alloc] init];
    [paymentMethod setString:@"getChargeAmount?"];
    
    NSString * url = [self.oGlobals buildURL:paymentMethod fromDictionary:params];
    
    NSURL *paymentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:paymentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    
    //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        // 3
        _chargeAmountArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableContainers
                                                               error:&e];
        NSLog(@"JSON: %@", [_chargeAmountArray objectAtIndex:0]);
        
        _amountFromWebservice = [[_chargeAmountArray objectAtIndex:0] floatValue];
        _totalAmount = [NSString stringWithFormat:@"%.2f", _amountFromWebservice];
        _STax1 = [[_chargeAmountArray objectAtIndex:1] floatValue];
        _STax2 = [[_chargeAmountArray objectAtIndex:2] floatValue];
        
        if(![_tfAmount isEqual:_tfTotal])
        {
            _hasDiscount = TRUE;
            _tfTotal.text = _totalAmount;
        }
        
        if(_STax1 + _STax2 > 0)
        {
            _hasTax = TRUE;
            _totalWithTax = _amountFromWebservice + _STax1 + _STax2;
            NSString *totalAmountWithTax = [NSString stringWithFormat:@"%.2f", _totalWithTax];
            _tfTotal.text = totalAmountWithTax;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was an error retrieving the charge codes."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    

}

//Enter charge
- (IBAction)enterCharge:(id)sender
{
    /**
     * Lots of empty strings because they may or may not be required for other Processors ie PowerPay or Mercury.
     * For example PaymentID to CarHolderName are all required for Mercury.
     */
    
    _Amount = [_tfAmount.text floatValue];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [_btnEnterCharge setEnabled:FALSE];
    
    float totalAmount = 0;
    float discAmount = 0;
    
    if(_hasDiscount)
    {
        totalAmount = _amountFromWebservice;
        discAmount = _chargeCodes.Amount - _amountFromWebservice;
    }
    else if (_hasTax)
    {
        totalAmount = _totalWithTax;
        discAmount = 0;
    } else {
        totalAmount = _chargeCodes.Amount;
    }
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID  forKey:@"UserGUID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_selectedAccount.AcctID] forKey:@"AcctID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_School.SchID] forKey:@"SchID"];
    [params setObject:[NSString stringWithFormat:@"%@", _lbChargeDate.text] forKey:@"strChgDate"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfDescription.text] forKey:@"ChgDesc"];
    [params setObject:[NSString stringWithFormat:@"%@", _chargeCodes.GLNo] forKey:@"GLNo"];
    [params setObject:[NSString stringWithFormat:@"%.2f", _amountFromWebservice]  forKey:@"Amount"];
    [params setObject:[NSString stringWithFormat:@"%f", totalAmount]  forKey:@"totalAmount"];
    [params setObject:[NSString stringWithFormat:@"%@", _chargeCodes.Kind] forKey:@"Kind"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_chargeCodes.Tax] forKey:@"STax"];
    [params setObject:[NSString stringWithFormat:@"%d", FALSE] forKey:@"POSTrans"];
    [params setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"POSI nv"];
    [params setObject:[NSString stringWithFormat:@"%hhd", _chargeCodes.PayOnline] forKey:@"PayOnline"];
    [params setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"TransPostHistID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)_School.SessionID] forKey:@"SessionID"];
    [params setObject:[NSString stringWithFormat:@"%f", discAmount] forKey:@"DiscAmt"];
    [params setObject:[NSString stringWithFormat:@"%f", _STax1] forKey:@"STax1"];
    [params setObject:[NSString stringWithFormat:@"%f", _STax2] forKey:@"STax2"];
    [params setObject:[NSString stringWithFormat:@"%@", _User.DisplayName] forKey:@"DisplayName"];
    
    
    NSMutableString *paymentMethod = [[NSMutableString alloc] init];
    [paymentMethod setString:@"enterCharge?"];
    
    NSString * url = [self.oGlobals buildURL:paymentMethod fromDictionary:params];
    
    NSURL *paymentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:paymentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    
    //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 3
        NSError *error = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Charge successfully applied."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        [_btnEnterCharge setEnabled:TRUE];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was an error retrieving the charge codes."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_btnEnterCharge setEnabled:TRUE];

    }];
    
    // 5
    [operation start];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//Dismiss keyboard on enter click
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    return _chargeTypeArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _chargeTypeArray[row];
}


/**
 * Updating Reference and Amount textfields after UiPickerView selection. Calls getAmount to see if there are is any tax or discount.
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    _chargeCodes = [_arrayOfChargeCodes objectAtIndex: row];
    if(_chargeCodes.ChgID == 0)
    {
        _tfAmount.text = @"0.00";
    } else if ([_chargeCodes.Kind isEqual:@"T"] && [_chargeCodes.ChgNo integerValue] < 4)
    {
        _tfAmount.text = [NSString stringWithFormat:@"%.2f", _selectedAccount.MTuition];
        _tfDescription.text = _chargeCodes.ChgDesc;
        _ChgID=_chargeCodes.ChgID;
        [self getAmountToCharge];

    } else {
        _tfAmount.text = [NSString stringWithFormat:@"%.2f", _chargeCodes.Amount];
        _tfDescription.text = _chargeCodes.ChgDesc;
        _ChgID=_chargeCodes.ChgID;
        [self getAmountToCharge];
    }
    
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
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = kbSize;
        kbSize.height = origKeySize.width;
        kbSize.width = origKeySize.height;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    _enterChargeScrollView.contentInset = contentInsets;
    _enterChargeScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

 }

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _enterChargeScrollView.contentInset = contentInsets;
    _enterChargeScrollView.scrollIndicatorInsets = contentInsets;
}

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
