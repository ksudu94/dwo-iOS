//
//  StudentViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "StudentViewController.h"
#import "StudentInformation.h"
#import "AFNetworking.h"
#import "LoginController.h"
#import "Student.h"
#import "Globals.h"
#import "User.h"
#import "School.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "TWTSideMenuViewController.h"


@implementation StudentViewController

/**
 * I'm putting this note here b/c I forgot how I did it the first time I did it. I did a segue from the cell in the StudentViewController in the IB to the tab bar controller. I then created a view controller equal to the first tab of that tab bar controller
 * Which in this case is the student information tab. I Then gave it a selected student from the list of students. 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogOut:)];

    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    self.navigationItem.leftBarButtonItem = self.leftBarButton;


    
    //A delegate allows one object to send data to another when an event happens
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.oGlobal = [[Globals alloc] init];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
    
    
    NSError *e = nil;
    self.User = [[User alloc] initWithDictionary:dictUser error:&e];
    self.School = [[School alloc] initWithDictionary:dictSchool error:&e];
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    //AcctID of 0 means get all students
    [params setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"AcctID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.School.SchID] forKey:@"SchID"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.User.UserID]  forKey:@"UserID"];
    [params setObject:self.User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getStudents?"];
    
    NSString * url = [self.oGlobal buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[self.oGlobal URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _data = (NSDictionary *) responseObject;
        [self saveStudents];
        [self.tableView reloadData];
        [defaults rm_setCustomObject:responseObject forKey:@"SavedStudents"];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"Error: %d", statusCode);
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"Time out brah");
        }

        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Students"
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
 * Open navigation menu
 */
- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}


- (void) LogOut: (id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserID"];
    [defaults synchronize];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.studentsObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"StudentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    Student *newStudent = [self.studentsObjects objectAtIndex: indexPath.row];
    [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",newStudent.FName,@" ",newStudent.LName];

    cell.textLabel.text = fullName;
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _studentTabBarController = (UITabBarController*) [segue destinationViewController];
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    _studentInformationController = [_studentTabBarController.viewControllers objectAtIndex: 0];
    _studentInformationController.selectedStudent = [_studentsObjects objectAtIndex:selectedIndex.row];
    _studentInformationController.User = _User;
    _studentInformationController.School = _School;
    
}

-(void) saveStudents {
    //triggered when all data is loaded
    NSError *e = nil;
    self.studentsObjects = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.data)
        {
            //Create account for every response
            self.Student = [[Student alloc] initWithDictionary:dictionary error:&e];
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            //student.DateReg = [oGlobal getDateFromJSON:[dictionary objectForKey:@"DateReg"]];
            
            [self.studentsObjects addObject:self.Student];
            
            
            
        }
    }
    
}

@end
