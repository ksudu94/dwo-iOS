//
//  EditStudentInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/14/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "EditStudentInformation.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"
#import "StudentInformation.h"
@interface EditStudentInformation ()

@end

@implementation EditStudentInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusPicker.dataSource = self;
    self.statusPicker.delegate = self;
    self.statusArray = @[@"Active",@"Inactive", @"Prospect", @"Deleted"];
    self.oGlobals = [[Globals alloc] init];

    // Do any additional setup after loading the view.
    _tfFname.text = _selectedStudent.FName;
    _tfLame.text = _selectedStudent.LName;
    _tfAddress.text = _selectedStudent.Address;
    _tfCity.text = _selectedStudent.City;
    _tfState.text = _selectedStudent.State;
    _tfZipCode.text = _selectedStudent.ZipCode;
    _tfPhone.text = _selectedStudent.Phone;
    _tfAccountName.text = _selectedStudent.AcctName;

    [self registerForKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    // Do any additional setup after loading the view.
}
- (IBAction)saveStudentInformationChanges:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    
    NSError *e = nil;
    self.selectedUser = [[User alloc] initWithDictionary:dictUser error:&e];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[NSString stringWithFormat:@"%d", _selectedStudent.StuID] forKey:@"StuID"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfFname.text] forKey:@"FName"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfLame.text] forKey:@"LName"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfAddress.text] forKey:@"Address"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfCity.text] forKey:@"City"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfState.text] forKey:@"State"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfZipCode.text] forKey:@"ZipCode"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfPhone.text] forKey:@"Phone"];
    [params setObject:[NSString stringWithFormat:@"%@", _tfAccountName.text] forKey:@"AcctName"];

    NSInteger row = [_statusPicker selectedRowInComponent:0];
    int intStatus = [self getStatus:[self.statusArray objectAtIndex:row]];
    
    [params setObject:[NSString stringWithFormat:@"%d", intStatus] forKey:@"Status"];
    [params setObject:[NSString stringWithFormat:@"%d", self.selectedUser.UserID] forKey:@"UserID"];
    [params setObject:self.selectedUser.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *saveStudentMethod = [[NSMutableString alloc] init];
    [saveStudentMethod setString:@"saveStudentInformation?"];
    
    NSString * url = [self.oGlobals buildURL:saveStudentMethod fromDictionary:params];
    
    NSURL *saveStudentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:saveStudentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    
    //Changing the response type to AFCompound allows for the serializer to accept non json objects.. ie a string
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strResponse = [operation.responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([strResponse isEqualToString:@"Changes saved"])
        {
            _selectedStudent.FName = [NSString stringWithFormat:@"%@",_tfFname.text];
            _selectedStudent.LName = [NSString stringWithFormat:@"%@",_tfLame.text];
            _selectedStudent.AcctName = [NSString stringWithFormat:@"%@", _tfAccountName.text];
            _selectedStudent.Address = [NSString stringWithFormat:@"%@",_tfAddress.text];
            _selectedStudent.City = [NSString stringWithFormat:@"%@", _tfCity.text];
            _selectedStudent.State = [NSString stringWithFormat:@"%@", _tfState.text];
            _selectedStudent.ZipCode = [NSString stringWithFormat:@"%@", _tfZipCode.text];
            _selectedStudent.Phone = [NSString stringWithFormat:@"%@", _tfPhone.text];
            _selectedStudent.Status = intStatus;
            
            [self.delegate addItemViewController:self didFinishEnteringItem:_selectedStudent];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            NSError *saveAccountError = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to save Student Information. Please try again."
                                                                message:[saveAccountError localizedDescription]
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 * Convert status to int value
 */
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


/*
 * Picker view methods that do stuff
 */
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



/**
 * Textfield stuff that handles the scrolling of thew view and dismissing the keyboard based on enter click or touching outside keybaord
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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
    _editStudentScrollView.contentInset = contentInsets;
    _editStudentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _editStudentScrollView.contentInset = contentInsets;
    _editStudentScrollView.scrollIndicatorInsets = contentInsets;
}

@end
