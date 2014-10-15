//
//  UITableViewController+AccountViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/10/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "UITableViewController+AccountViewController.h"
#import "Account.h"
#import "AFNetworking.h"


@interface AccountViewController() {
    NSMutableArray *accountsObjects;
    NSMutableData *_receivedData;
    NSDateFormatter *dateFormatter;
    Account *acc;

}

@property(strong) NSDictionary *data;

@end


@implementation  AccountViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *myURL = [NSURL URLWithString:@"http://app.akadasoftware.com/ws/Service1.svc/getAccountsJS?Order=%20&SchID=11&UserID=575&UserGUID=24b933dc-dbe8-464e-ac93-1e7cfa0db5a4"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    //A delegate allows one object to send data to another when an event happens
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        self.data = (NSDictionary *) responseObject;
        [self saveAccounts];
        [self.tableView reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self->accountsObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *id = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    //Method is hit everytime a cell is created so create a new account object from the accounts array based on the cell position
    Account *newAccount = [accountsObjects objectAtIndex: indexPath.row];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *name = [newAccount.FName stringByAppendingString: newAccount.LName];
    //NSDate *date = newAccount.DateReg;
    //NSString *strDate = [dateFormatter stringFromDate: date];
    //int *acctid = newAccount.AcctID ;
    
    cell.textLabel.text = name;
    return cell;
}


-(void) saveAccounts {
    //triggered when all data is loaded
    NSError *e = nil;
    accountsObjects = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.data)
        {
            //Create account for every response
            acc = [[Account alloc] initWithDictionary:dictionary error:&e];
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            acc.DateReg = [acc getDateFromJSON:[dictionary objectForKey:@"DateReg"]];
            //Add the newly created account to an array of account objects
            [accountsObjects addObject:acc];
            //NSLog(@"First Name: %@", [dictionary objectForKey:@"FName"]);
            //NSLog(@"Last Name: %@", [dictionary objectForKey:@"LName"]);
            //NSLog(@"AcctID: %@", [dictionary objectForKey:@"AcctID"]);
            //NSLog(@"Date: %@", [acc getDateFromJSON:[dictionary objectForKey:@"DateReg"]]);
            
            
        }
    }
    
}

@end
