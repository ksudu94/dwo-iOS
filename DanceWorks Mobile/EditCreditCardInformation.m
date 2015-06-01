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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

    self.tfFname.text = _selectedAccount.CCFName;
    self.tfLame.text = _selectedAccount.CCLName;
    self.tfAddress.text = _selectedAccount.CCAddress;
    self.tfCity.text = _selectedAccount.CCCity;
    self.tfState.text = _selectedAccount.CCState;
    self.tfZip.text = _selectedAccount.CCZip;

    
    // Do any additional setup after loading the view.
}

- (IBAction)checkCreditCardInformation:(id)sender
{
    
    {
        NSError* error = nil;
        if([self.tfCC.text isEqualToString:@""] || [self.tfExpDate.text isEqualToString:@""])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error, no blank fields allowed."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            UIAlertView *invalidCreditCard = [[UIAlertView alloc] initWithTitle:@"Invalid credit card number."
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
            
            NSString *newCardNumber = self.tfCC.text;
            int cardNumberLength = newCardNumber.length;
            NSString *firstCharacter = [newCardNumber substringToIndex:1];
            int firstDigit = [firstCharacter integerValue];
            
            if(cardNumberLength > 0)
            {
                switch (firstDigit) {
                    case 3:
                        if(cardNumberLength == 15)
                        {
                            [self saveCreditCardInformation];
                        }
                        break;
                    case 4:
                        if(cardNumberLength == 13 || cardNumberLength == 16)
                        {
                            [self saveCreditCardInformation];
                            
                        }
                        break;
                    case 5:
                        if(cardNumberLength == 16)
                        {
                            [self saveCreditCardInformation];
                            
                        }
                        break;
                    case 6:
                        if(cardNumberLength == 16)
                        {
                            [self saveCreditCardInformation];
                            
                        }
                        break;
                    default:
                        [invalidCreditCard show];
                        break;
                }
            }
            else
            {
                [invalidCreditCard show];
                
            }
            
        }

    }
}


- (void) saveCreditCardInformation
{
    NSString *CCExpireDate = self.tfExpDate.text;
    int cardNumberLength = CCExpireDate.length;
    NSString *firstCharacter = [CCExpireDate substringToIndex:1];
    int firstDigit = [firstCharacter integerValue];
    BOOL validDate = NO;
    
    NSError* error = nil;
    UIAlertView *invalidExpireDate = [[UIAlertView alloc] initWithTitle:@"Invalid Expiration Date."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
    if(!firstDigit == 0)
    {
        if(cardNumberLength == 4)
        {
            validDate = YES;
        }
        else
        {
            [invalidExpireDate show];
        }
    }
    else
    {
      if(cardNumberLength == 3)
      {
          validDate = YES;
      }
      else
      {
          [invalidExpireDate show];
      }
    }
    
    if(validDate)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        //Pull stored objects from NSUserDefaults as dictionaries
        NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
        NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
        
        NSError *e = nil;
        self.selectedUser = [[User alloc] initWithDictionary:dictUser error:&e];
        self.selectedSchool = [[School alloc] initWithDictionary:dictSchool error:&e];
        self.oGlobals = [[Globals alloc] init];
        
        
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedUser.UserID] forKey:@"UserID"];
        [params setObject:self.selectedUser.UserGUID forKey:@"UserGUID"];
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedAccount.AcctID] forKey:@"AcctID"];
        [params setObject:[NSString stringWithFormat:@"%@", self.selectedSchool.CCUserName] forKey:@"CCUser"];
        [params setObject:[NSString stringWithFormat:@"%@", self.selectedSchool.CCPassword] forKey:@"CCPass"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfCC.text] forKey:@"CardNumber"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfExpDate.text] forKey:@"CardExpire"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfFname.text] forKey:@"CCFName"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfLame.text] forKey:@"CCLName"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfAddress.text] forKey:@"CCAddress"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfCity.text] forKey:@"CCCity"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfState.text] forKey:@"CCState"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfZip.text] forKey:@"CCZipCode"];
        [params setObject:[NSString stringWithFormat:@"%f", self.selectedSchool.CCMaxAmt] forKey:@"MaxAmount"];
        [params setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"MerchantNumber"];
        [params setObject:[NSString stringWithFormat:@"%@", @"Kyle"] forKey:@"UserName"];
        
        NSMutableString *saveCreditCardMethod = [[NSMutableString alloc] init];
        [saveCreditCardMethod setString:@"saveCreditCardInformation?"];
        
        NSString * url = [self.oGlobals buildURL:saveCreditCardMethod fromDictionary:params];
        
        NSURL *saveCreditCardURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:saveCreditCardURL];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
        
        //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
        operation.responseSerializer = [AFCompoundResponseSerializer serializer];
        //operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            int ConsentID = [operation.responseString intValue];
            if(ConsentID > 0)
            {
                self.selectedAccount.CCFName = [NSString stringWithFormat:@"%@",self.tfFname.text];
                self.selectedAccount.CCLName = [NSString stringWithFormat:@"%@",self.tfLame.text];
                self.selectedAccount.CCAddress = [NSString stringWithFormat:@"%@",self.tfAddress.text];
                self.selectedAccount.CCCity = [NSString stringWithFormat:@"%@",self.tfCity.text];
                self.selectedAccount.CCState = [NSString stringWithFormat:@"%@",self.tfState.text];
                self.selectedAccount.CCZip = [NSString stringWithFormat:@"%@",self.tfZip.text];
                self.selectedAccount.CCExpire = [NSString stringWithFormat:@"%@",self.tfExpDate.text];
                self.selectedAccount.CCConsentID = ConsentID;
                
                [self.delegate addItemViewController:self didFinishEnteringItem:self.selectedAccount];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                NSError *powerPayError = nil;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save credit card information. Please try again."
                                                                    message:[powerPayError localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Saving Information"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        // 5
        [operation start];
        

    }
    
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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = kbSize;
        kbSize.height = origKeySize.width;
        kbSize.width = origKeySize.height;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _editCreditCardScrollView.contentInset = contentInsets;
    _editCreditCardScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
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
