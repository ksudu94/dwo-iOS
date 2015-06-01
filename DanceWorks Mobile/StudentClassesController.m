//
//  StudentClassesController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/5/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "StudentClassesController.h"
#import "User.h"
#import "School.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"


@implementation StudentClassesController

-(void) viewDidLoad
{
    [super viewDidLoad];
    _oGlobals = [[Globals alloc] init];
    [self registerForKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

    // Get sessions
    [self getSessions];

    
}


-(void) getSessions
{
    
     NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSString *Order=[NSString stringWithFormat:@"%@%ld%@%d%@", @" Where schid=", (long)_School.SchID, @" AND DisplaySession=",true,@"ORDER BY SDATE,EDATE,SessionName"];
    [params setObject:Order forKey:@"Order"];
    [params setObject:[NSString stringWithFormat:@"%d", _User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getSessions?"];
    
    NSString * url = [_oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[_oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _sessionDictionaries = (NSDictionary *) responseObject;
        [self saveSessions];
        
        //Auto select first session
        _selectedSession = [_sessionObjects objectAtIndex: 0];
        //Populate downpicker w/ Session Names
        _downPicker = [[DownPicker alloc] initWithTextField: _tfSession withData:_sessionNameArray];
        [_downPicker addTarget:self action:@selector(updateSession) forControlEvents:(UIControlEventValueChanged)];
        _downPicker.getTextField.text = _selectedSession.SessionName;
        [self getStudentClasses];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"Error: %ld", (long)statusCode);
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"Time out brah");
        }
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Session"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

}

/*
 * Converts the session dictionaries to session objects
 */
-(void) saveSessions
{
    //triggered when all data is loaded
    NSError *e = nil;
    _sessionObjects = [[NSMutableArray alloc] init];
    _sessionMenuItems = [[NSMutableArray alloc] init];
    _sessionNameArray = [[NSMutableArray alloc] init];

    int sessionPosition = 0;
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in _sessionDictionaries)
        {
            _Session = [[Session alloc] initWithDictionary:dictionary error:&e];
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            _Session.EDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"EDate"]];
            _Session.SessionDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"SessionDate"]];
            _Session.SDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"SDate"]];
            
            
            [_sessionObjects addObject: _Session];
            [_sessionNameArray addObject:_Session.SessionName];
            
        }
    }
    
}

/**
 * Get all the student classes
 */
-(void) getStudentClasses
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[NSString stringWithFormat:@"%d", _selectedStudent.StuID]  forKey:@"StuID"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedSession.SessionID]  forKey:@"SessionID"];
    [params setObject:[NSString stringWithFormat:@"%d", FALSE]  forKey:@"OLReg"];
    [params setObject:[NSString stringWithFormat:@"%d", _User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getStuClasses?"];
    
    NSString * url = [_oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[_oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _classesDictionaries = (NSDictionary *) responseObject;
        [self saveStudentClasses];
        [_stuClassTable reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"Error: %ld", (long)statusCode);
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"Time out brah");
        }
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Classes"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

/*
 * Converts the classes dictionaries to classes objects
 */
-(void) saveStudentClasses
{
    //triggered when all data is loaded
    NSError *e = nil;
    _classesObjects = [[NSMutableArray alloc] init];
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in _classesDictionaries)
        {
            _selectedClass = [[StudentClasses alloc] initWithDictionary:dictionary error:&e];
            [_classesObjects addObject: _selectedClass];
        }
    }

}

/**
 * Once a new Session is choosen, update the selected Session variable, re-populate student class list
 */
-(void) updateSession
{
    NSInteger row;
    row = [_downPicker.getPickerView selectedRowInComponent:0];
    _selectedSession = [_sessionObjects objectAtIndex:row];
    [self getStudentClasses];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _classesObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"StudentClassesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    StudentClasses *stuClass = [_classesObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = stuClass.ClDescription;
    
    return cell;
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
    
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //_editStudentScrollView.contentInset = contentInsets;
    //_editStudentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //_editStudentScrollView.contentInset = contentInsets;
    //_editStudentScrollView.scrollIndicatorInsets = contentInsets;
}
@end
