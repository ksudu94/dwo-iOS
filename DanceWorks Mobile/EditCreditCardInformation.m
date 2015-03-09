//
//  EditCreditCardInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 2/27/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "EditCreditCardInformation.h"
#import "AccountInformation.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"


@interface EditCreditCardInformation ()

@end

@implementation EditCreditCardInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Cancel";
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    [self registerForKeyboardNotifications];

    self.tfFname.text = _selectedAccount.CCFName;
    self.tfLame.text = _selectedAccount.CCLName;
    self.tfAddress.text = _selectedAccount.CCAddress;
    self.tfCity.text = _selectedAccount.CCCity;
    self.tfState.text = _selectedAccount.CCState;
    self.tfZip.text = _selectedAccount.CCZip;

    
    // Do any additional setup after loading the view.
}

- (IBAction)saveCreditCard:(id)sender
{
    NSLog(@"LOL");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.editCreditCardScrollView.contentInset = contentInsets;
    self.editCreditCardScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //    [self.editAccountScrollView scrollRectToVisible:activeField.frame animated:YES];
    //}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.editCreditCardScrollView.contentInset = contentInsets;
    self.editCreditCardScrollView.scrollIndicatorInsets = contentInsets;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
