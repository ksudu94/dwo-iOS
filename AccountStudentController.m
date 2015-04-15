//
//  AccountStudentController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/5/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "AccountStudentController.h"
#import "AccountInformation.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AFNetworking.h"
#import "Student.h"
#import "AccountTransactionsController.h"
#import "PaymentViewController.h"
#import "ChargeViewController.h"


@implementation AccountStudentController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];
    
    NSError *e = nil;
    self.user = [[User alloc] initWithDictionary:dictUser error:&e];
    self.school = [[School alloc] initWithDictionary:dictSchool error:&e];
    self.oGlobals = [[Globals alloc] init];
    
    self.leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToList)];
        
    self.navigationItem.leftBarButtonItem = self.leftBarButton;
   
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    //The acctid ensures it does not get the whole list
    [params setObject:[NSString stringWithFormat:@"%d", self.selectedAccount.AcctID] forKey:@"AcctID"];
    [params setObject:[NSString stringWithFormat:@"%d", self.School.SchID] forKey:@"SchID"];
    [params setObject:[NSString stringWithFormat:@"%d", self.User.UserID]  forKey:@"UserID"];
    [params setObject:self.User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getStudents?"];
    
    NSString * url = [self.oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        self.data = (NSDictionary *) responseObject;
        [self saveStudents];
    
        [self.accountStudentTable reloadData];
        
        
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

- (void)backToList
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.studentsObject.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"Cell";
    UITableViewCell *cell = [self.accountStudentTable dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
    }
    Student *newStudent = [self.studentsObject objectAtIndex: indexPath.row];
    
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",newStudent.FName,@" ",newStudent.LName];
    
    cell.textLabel.text = fullName;
    return cell;
}

-(void) saveStudents {
    //triggered when all data is loaded
    NSError *e = nil;
    self.studentsObject = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.data)
        {
            //Create account for every response
            self.Student = [[Student alloc] initWithDictionary:dictionary error:&e];
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            //student.DateReg = [oGlobal getDateFromJSON:[dictionary objectForKey:@"DateReg"]];
            
            [self.studentsObject addObject:self.Student];
            
            
            
        }
    }
    
}


-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if([viewController isKindOfClass:[AccountStudentController class]])
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
