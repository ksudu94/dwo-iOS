//
//  EditAccountInformationController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 2/2/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "EditAccountInformationController.h"
#import "AccountInformation.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"

@interface EditAccountInformationController ()
@end

@implementation EditAccountInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oGlobals = [[Globals alloc] init];

    self.statusPicker.dataSource = self;
    self.statusPicker.delegate = self;
    self.statusArray = @[@"Active",@"Inactive", @"Prospect", @"Deleted"];
    self.navigationItem.leftBarButtonItem.title = @"Back";
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    
    NSError *e = nil;
    self.selectedUser = [[User alloc] initWithDictionary:dictUser error:&e];

    // Do any additional setup after loading the view.
    self.tfFname.text = _selectedAccount.FName;
    self.tfLame.text = _selectedAccount.LName;
    self.tfAddress.text = _selectedAccount.Address;
    self.tfCity.text = _selectedAccount.City;
    self.tfState.text = _selectedAccount.State;
    self.tfZipCode.text = _selectedAccount.ZipCode;
    self.tfPhone.text = _selectedAccount.Phone;
    self.tfEmail.text = _selectedAccount.EMail;
    [self registerForKeyboardNotifications];
    
}
- (IBAction)saveAccountChanges:(id)sender
{
    {
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedAccount.AcctID] forKey:@"AcctID"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfFname.text] forKey:@"FName"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfLame.text] forKey:@"LName"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfEmail.text] forKey:@"EMail"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfAddress.text] forKey:@"Address"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfCity.text] forKey:@"City"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfState.text] forKey:@"State"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfZipCode.text] forKey:@"ZipCode"];
        [params setObject:[NSString stringWithFormat:@"%@", self.tfPhone.text] forKey:@"Phone"];
        
        NSInteger row = [self.statusPicker selectedRowInComponent:0];
        int intStatus = [self getStatus:[self.statusArray objectAtIndex:row]];
        
        [params setObject:[NSString stringWithFormat:@"%d", intStatus] forKey:@"Status"];
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedAccount.TuitionSel] forKey:@"TuitionSel"];
        [params setObject:[NSString stringWithFormat:@"%d", TRUE] forKey:@"checkName"];
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedUser.UserID] forKey:@"UserID"];
        //NSLog(@"%@", self.selectedUser.UserGUID);
        [params setObject:[NSString stringWithFormat:@"9669ce7a-eec7-42fc-9bb2-af9d46c85e91"] forKey:@"UserGUID"];
        //[params setObject:self.selectedUser.UserGUID forKey:@"UserGUID"];

        NSMutableString *saveAccountMethod = [[NSMutableString alloc] init];
        [saveAccountMethod setString:@"saveAccountInformation?"];
        
        NSString * url = [self.oGlobals buildURL:saveAccountMethod fromDictionary:params];
        
        NSURL *saveAccountURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:saveAccountURL];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];

        //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
        operation.responseSerializer = [AFCompoundResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.selectedAccount.FName = [NSString stringWithFormat:@"%@",self.tfFname.text];
            self.selectedAccount.LName = [NSString stringWithFormat:@"%@",self.tfLame.text];
            self.selectedAccount.EMail = [NSString stringWithFormat:@"%@",self.tfEmail.text];
            self.selectedAccount.Address = [NSString stringWithFormat:@"%@",self.tfAddress.text];
            self.selectedAccount.City = [NSString stringWithFormat:@"%@",self.tfCity.text];
            self.selectedAccount.State = [NSString stringWithFormat:@"%@",self.tfState.text];
            self.selectedAccount.ZipCode = [NSString stringWithFormat:@"%@",self.tfZipCode.text];
            self.selectedAccount.Phone = [NSString stringWithFormat:@"%@",self.tfPhone.text];
            self.selectedAccount.Status = intStatus;
            
            [self.delegate addItemViewController:self didFinishEnteringItem:self.selectedAccount];
            [self.navigationController popViewControllerAnimated:YES];
        
            
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
-(int) getStatus:(NSString *) status
{
    int intStatus;
    if([status isEqualToString:@"Active"])
    {
        intStatus = 0;
    }
    else if([status isEqualToString:@"Inactive"])
    {
        intStatus = 1;
    }
    
    else if([status isEqualToString:@"Prospect"])
    {
        intStatus = 2;
    }
    else
    {
        intStatus = 3;
    }

    return intStatus;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _statusArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _statusArray[row];
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
    self.editAccountScrollView.contentInset = contentInsets;
    self.editAccountScrollView.scrollIndicatorInsets = contentInsets;
    
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
    self.editAccountScrollView.contentInset = contentInsets;
    self.editAccountScrollView.scrollIndicatorInsets = contentInsets;
}

@end
