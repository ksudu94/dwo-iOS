//
//  EnrollStudentViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/27/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "EnrollStudentViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"
#import "DownPicker.h"
#import "ClassCell.h"


@implementation EnrollStudentViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    _oGlobals = [[Globals alloc] init];
    
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
        
        int currentSessionPosition = [_oGlobals getCurrentSessionPosition:_sessionObjects forSchool:_School];
        //Auto select first session
        _selectedSession = [_sessionObjects objectAtIndex: currentSessionPosition];
        
        //Populate downpicker w/ Session Names
        _downPicker = [[DownPicker alloc] initWithTextField: _tfSession withData:_sessionNameArray];
        _tfSession.text = _selectedSession.SessionName;
        
        [_downPicker addTarget:self action:@selector(updateSession) forControlEvents:(UIControlEventValueChanged)];
        _downPicker.getTextField.text = _selectedSession.SessionName;
        [self getSchoolClasses];
        
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
    _sessionNameArray = [[NSMutableArray alloc] init];
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in _sessionDictionaries)
        {
            _selectedSession = [[Session alloc] initWithDictionary:dictionary error:&e];
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            _selectedSession.EDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"EDate"]];
            _selectedSession.SessionDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"SessionDate"]];
            _selectedSession.SDate = [_oGlobals getDateFromJSON:[dictionary objectForKey:@"SDate"]];
            
            
            [_sessionObjects addObject: _selectedSession];
            [_sessionNameArray addObject:_selectedSession.SessionName];
            
        }
    }
    
}

/**
 * Get all the school classes
 */
-(void) getSchoolClasses
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[NSString stringWithFormat:@"%d", _selectedStudent.StuID]  forKey:@"StuID"];
    /**
     * Ask DJ about this. Android side the saved value for StaffID is alwasy 0.. Here it is.. usually 45 or so.
     */
    [params setObject:[NSString stringWithFormat:@"%d", 0]  forKey:@"StaffID"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedSession.SessionID]  forKey:@"SessionID"];
    [params setObject:[NSString stringWithFormat:@"%d", 1]  forKey:@"intBoolEnroll"];
    [params setObject:[NSString stringWithFormat:@"%d", _User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getSchoolClasses?"];
    
    NSString * url = [_oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[_oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _classesDictionaries = (NSDictionary *) responseObject;
        [self saveSchoolClasses];
        [_enrollClassTable reloadData];
        
        
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
-(void) saveSchoolClasses
{
    //triggered when all data is loaded
    NSError *e = nil;
    _classesObjects = [[NSMutableArray alloc] init];
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in _classesDictionaries)
        {
            _selectedClass = [[SchoolClasses alloc] initWithDictionary:dictionary error:&e];
            [_classesObjects addObject: _selectedClass];
        }
    }
    
}

-(void) getClassConflicts
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.ClMax]  forKey:@"ClMax"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.ClCur]  forKey:@"ClCur"];
    [params setObject:_selectedClass.ClTime forKey:@"strClTime"];
    [params setObject:_selectedClass.ClStop forKey:@"strClStop"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Multiday]  forKey:@"MultiDay"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Monday]  forKey:@"Monday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Tuesday]  forKey:@"Tuesday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Wednesday]  forKey:@"Wednesday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Thursday]  forKey:@"Thursday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Friday]  forKey:@"Friday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Saturday]  forKey:@"Saturday"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.Sunday]  forKey:@"Sunday"];
    [params setObject:_selectedClass.ClDayNo forKey:@"strClDayNo"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedStudent.StuID]  forKey:@"StuID"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClass.ClID]  forKey:@"ClID"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedSession.SessionID]  forKey:@"SessionID"];
    [params setObject:[NSString stringWithFormat:@"%d", _User.UserID]  forKey:@"UserID"];
    [params setObject:_User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"checkClassEnrollment?"];
    
    NSString * url = [_oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[_oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _conflictsDictionary = (NSDictionary *) responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"Error: %ld", (long)statusCode);
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"Time out brah");
        }
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Conflicts"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
}

/**
 * Once a new Session is choosen, update the selected Session variable, re-populate student class list
 */
-(void) updateSession
{
    NSInteger row;
    row = [_downPicker.getPickerView selectedRowInComponent:0];
    _selectedSession = [_sessionObjects objectAtIndex:row];
    [self getSchoolClasses];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_classesObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"ClassCell";
    _selectedClassCell = (ClassCell *) [tableView dequeueReusableCellWithIdentifier:id];
    
    if(_selectedClassCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassCell" owner:self options:nil];
        _selectedClassCell = [nib objectAtIndex:0];
    }
    
    SchoolClasses *schoolClass = [_classesObjects objectAtIndex:indexPath.row];
    
    if([schoolClass.ClType isEqualToString:@""])
        _selectedClassCell.lbClassType.text = @"N/A";
    else
        _selectedClassCell.lbClassType.text = schoolClass.ClType;
    [_selectedClassCell.lbClassType sizeToFit];
   
    if([schoolClass.ClInstructor isEqualToString:@""])
        _selectedClassCell.lbCassInstructor.text = @"N/A";
    else
        _selectedClassCell.lbCassInstructor.text = schoolClass.ClInstructor;
    [_selectedClassCell.lbCassInstructor sizeToFit];
 
    _selectedClassCell.lbClassDescription.text = [NSString stringWithFormat:@"%@%@%@", schoolClass.ClLevel, @" - ", schoolClass.ClDescription];;
    [_selectedClassCell.lbClassDescription sizeToFit];

   
    NSString *Day= @"";

    if (schoolClass.Multiday) {
        if (schoolClass.Monday) {
            Day= @"Mon";
        }
        if (schoolClass.Tuesday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Tues";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Tues"];
            }
        }
        if (schoolClass.Wednesday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Wed";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Wed"];
            }
        }
        if (schoolClass.Thursday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Thur";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Thur"];
            }
        }
        if (schoolClass.Friday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Fri";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Fri"];
            }
        }
        if (schoolClass.Saturday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Sat";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Sat"];
            }
        }
        if (schoolClass.Sunday) {
            if ([Day isEqualToString:@""]) {
                Day= @"Sun";
            } else {
                Day = [NSString stringWithFormat:@"%@%@", Day, @"/Sun"];
            }
        }
    } else {
        Day = schoolClass.ClDay;
    }

    Day = [NSString stringWithFormat:@"%@%@%@%@%@", Day, @" From ", schoolClass.ClStart, @" - ", schoolClass.ClStop];
    _selectedClassCell.lbClassTime.text = Day;
    
    
    switch (schoolClass.EnrollmentStatus) {
        case 0:
            /**
             * Student not enrolled or waitlisted
             */
            [_selectedClassCell setBackgroundColor:[UIColor clearColor]];
            _selectedClassCell.lbEnrollmentStatus.text = @"";
            break;
        case 1:
            /**
             * Student already enrolled in class
             */
            [_selectedClassCell setBackgroundColor:[UIColor greenColor]];
            _selectedClassCell.lbEnrollmentStatus.text = @"Enrolled";
            break;
        case 2:
            /**
             * Student registered online, enrolled in class but not approved yet
             */
            [_selectedClassCell setBackgroundColor:[UIColor redColor]];
            _selectedClassCell.lbEnrollmentStatus.text = @"Pending Approval";
            break;
        case 3:
            /**
             * Student on waitlist
             */
            [_selectedClassCell setBackgroundColor:[UIColor yellowColor]];
            _selectedClassCell.lbEnrollmentStatus.text = @"On wait list";
            break;
        default:
            [_selectedClassCell setBackgroundColor:[UIColor clearColor]];
            _selectedClassCell.lbEnrollmentStatus.text = @"";
            break;

    }
    [_selectedClassCell.lbEnrollmentStatus setFont:[UIFont boldSystemFontOfSize:17]];

    return _selectedClassCell;
}


/**
 * Dynamic Cell Height
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0f;

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassCell" owner:self options:nil];
    _selectedClassCell = [nib objectAtIndex:0];
    
    for(UIView* view in _selectedClassCell.subviews)
    {
        cellHeight += view.frame.size.height;
    }
    
    return cellHeight;
}


/**
 * Handling cell selection
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected");
    _selectedClass = [_classesObjects objectAtIndex:indexPath.row];
    [self getClassConflicts];
}

@end
