//
//  AccountTransactionsController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/8/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "AccountTransactionsController.h"
#import "AccountInformation.h"
#import "AccountStudentController.h"
#import "AFNetworking.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AccountTransactions.h"
#import "AccountTransactionsCell.h"

@implementation AccountTransactionsController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    
    NSError *e = nil;
    self.user = [[User alloc] initWithDictionary:dictUser error:&e];
    self.oGlobals = [[Globals alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    //The acctid ensures it does not get the whole list
    [params setObject:@" ORDER BY TDate DESC" forKey:@"Order"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.selectedAccount.AcctID] forKey:@"AcctID"];
    [params setObject:[NSString stringWithFormat:@"%d", self.User.UserID]  forKey:@"UserID"];
    [params setObject:self.User.UserGUID forKey:@"UserGUID"];
    
    NSMutableString *studentMethod = [[NSMutableString alloc] init];
    [studentMethod setString:@"getAccountTransactions?"];
    
    NSString * url = [self.oGlobals buildURL:studentMethod fromDictionary:params];
    
    NSURL *studentURL =  [NSURL URLWithString:[self.oGlobals URLEncodeString:url]];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:studentURL];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        self.data = (NSDictionary *) responseObject;
        [self saveTransactions];
        
        [self.transactionTable reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Account Transactions"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.transactionsObject.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"AccountTransactionsCell";
    self.selectedTransactionCell = (AccountTransactionsCell *) [tableView dequeueReusableCellWithIdentifier:id];
    
    if(self.selectedTransactionCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountTransactionCell" owner:self options:nil];
        self.selectedTransactionCell = [nib objectAtIndex:0];
    }
    AccountTransactions *transactions = [self.transactionsObject objectAtIndex: indexPath.row];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *formatedDate = [dateFormatter stringFromDate: transactions.TDate ];
    NSString *formattedAmount = [NSString stringWithFormat:@"%.2f", transactions.Amount];
    NSString *formattedBalance = [NSString stringWithFormat:@"%.2f", transactions.Balance];

    
    NSString *firstLine=[NSString stringWithFormat:@"%@%@%@",formatedDate,@" - ",transactions.TDesc];
    NSString *strAmount=[NSString stringWithFormat:@"%@%@",@"Amount - $ ",formattedAmount];

    //self.selectedTransactionCell.dateLabel.text = formatedDate;
    //self.selectedTransactionCell.typeLabel.text = transactions.Type;
    self.selectedTransactionCell.descLabel.text = firstLine;
    [self.selectedTransactionCell.descLabel sizeToFit ];
    self.selectedTransactionCell.amountLabel.text = strAmount;
    
    return self.selectedTransactionCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // UILabel *myLabel;
    /*CGSize descSize = [self.selectedTransactionCell.descLabel.text sizeWithFont:self.selectedTransactionCell.descLabel.font
                                constrainedToSize: _selectedTransactionCell.descLabel.frame.size
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize dateSize = [self.selectedTransactionCell.dateLabel.text sizeWithFont:self.selectedTransactionCell.dateLabel.font
                                                                constrainedToSize: _selectedTransactionCell.dateLabel.frame.size
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize amountSize = [self.selectedTransactionCell.amountLabel.text sizeWithFont:self.selectedTransactionCell.amountLabel.font
                                                              constrainedToSize: _selectedTransactionCell.amountLabel.frame.size
                                                                  lineBreakMode:NSLineBreakByWordWrapping];

    
    CGSize typeSize = [self.selectedTransactionCell.typeLabel.text sizeWithFont:self.selectedTransactionCell.typeLabel.font
                                                              constrainedToSize: _selectedTransactionCell.typeLabel.frame.size
                                                                  lineBreakMode:NSLineBreakByWordWrapping];


    
    CGFloat cellHeight = dateSize.height + descSize.height + typeSize.height + dateSize.height;
    
   
     return cellHeight;
     */
    return 70;

}


-(void) saveTransactions
{
    //triggered when all data is loaded

    NSError *e = nil;
    self.transactionsObject = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.data)
        {
            //Create account transaction for every response
            self.selectedAccountTransaction = [[AccountTransactions alloc] initWithDictionary:dictionary error:&e];
            self.selectedAccountTransaction.TDate =[_oGlobals getDateFromJSON:[dictionary objectForKey:@"TDate"]];
            [self setTypeString:self.selectedAccountTransaction];
            [self.transactionsObject addObject:self.selectedAccountTransaction];
            
            
            
        }
    }
    
}

-(void) setTypeString:(AccountTransactions *) selectedAccountTransaction
{
    if([self.selectedAccountTransaction.Type isEqualToString:@"C"])
    {
        self.selectedAccountTransaction.Type = @"Charge";
    }
    else if([self.selectedAccountTransaction.Type isEqualToString:@"P"])
    {
        self.selectedAccountTransaction.Type = @"Payment";
    }
    
    else if([self.selectedAccountTransaction.Type isEqualToString:@"M"])
    {
        self.selectedAccountTransaction.Type = @"Credit";
    }
    
    else if([self.selectedAccountTransaction.Type isEqualToString:@"R"])
    {
        self.selectedAccountTransaction.Type = @"Refund";
    }
    else
    {
        self.selectedAccountTransaction.Type = @"Error";
    }
    
}

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if([viewController isKindOfClass:[AccountInformation class]])
    {
        AccountInformation *informationController = (AccountInformation *) viewController;
        informationController.selectedAccount = self.selectedAccount;
        
    }
    else if([viewController isKindOfClass:[AccountStudentController class]])
    {
        AccountStudentController *studentController = (AccountStudentController *) viewController;
        studentController.selectedAccount = self.selectedAccount;
    }
    
    return TRUE;
}

@end
