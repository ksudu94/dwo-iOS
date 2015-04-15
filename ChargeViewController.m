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

@interface ChargeViewController ()

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chargeTypePicker.dataSource = self;
    self.chargeTypePicker.delegate = self;
    self.chargeTypeArray = @[@"Registration", @"Tuition", @"Late Charge", @"Costume", @"Miscellaneous", @"Processing Fee"];
    self.oGlobals = [[Globals alloc] init];
    

    NSString *currentDate = [_oGlobals getTime];
    
    [_lbChargeDate setText:currentDate];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.enterChargeScrollView.contentInset = contentInsets;
    self.enterChargeScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.enterChargeScrollView.contentInset = contentInsets;
    self.enterChargeScrollView.scrollIndicatorInsets = contentInsets;
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
