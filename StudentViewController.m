//
//  StudentViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "StudentViewController.h"
#import "AFNetworking.h"
#import "LoginController.h"
#import "Student.h"
#import "Globals.h"
#import "User.h"
#import "School.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface StudentViewController() {
    NSMutableArray *studentsObjects;
    NSMutableData *_receivedData;
    NSDateFormatter *dateFormatter;
    Student *student;
    Globals *oGlobal;
    
    
}

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) School *school;

@property(strong) NSDictionary *data;

@end


@implementation StudentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    //A delegate allows one object to send data to another when an event happens
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    oGlobal = [[Globals alloc] init];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
    
    
    NSError *e = nil;
    self.user = [[User alloc] initWithDictionary:dictUser error:&e];
    self.school = [[School alloc] initWithDictionary:dictSchool error:&e];
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:@" Where schid=11" forKey:@"Where"];
    [params setObject:[NSString stringWithFormat:@"%d", self.user.UserID]  forKey:@"UserID"];
    [params setObject:self.user.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getStudents?"];
    
    NSString * url = [oGlobal buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[oGlobal URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        self.data = (NSDictionary *) responseObject;
        [self saveStudents];
        [self.tableView reloadData];
        [defaults rm_setCustomObject:responseObject forKey:@"SavedStudents"];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
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

- (void) LogOut: (id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserID"];
    [defaults synchronize];
    //[defaults setInteger:UserID forKey:@"UserID"];
    [self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    
    NSLog( @"Button clicked." );
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
    return self->studentsObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    Student *newStudent = [studentsObjects objectAtIndex: indexPath.row];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *name = [newStudent.FName stringByAppendingString: newStudent.LName];
    
    cell.textLabel.text = name;
    return cell;
}

-(void) saveStudents {
    //triggered when all data is loaded
    NSError *e = nil;
    studentsObjects = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.data)
        {
            //Create account for every response
            student = [[Student alloc] initWithDictionary:dictionary error:&e];
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            //student.DateReg = [oGlobal getDateFromJSON:[dictionary objectForKey:@"DateReg"]];
            
            [studentsObjects addObject:student];
            
            
            
        }
    }
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
