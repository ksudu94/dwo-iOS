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
#import "PaymentViewController.h"
#import "ChargeViewController.h"


@implementation AccountTransactionsController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;

    [self getAccountTransactions];
    
}

/**
 * Pull to refresh stuff implemented using our UITableView
 */
-(void) viewDidDisappear:(BOOL)animated
{
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = _transactionTable;
    
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(getAccountTransactions) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = _refreshControl;

}

-(void) getAccountTransactions
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //Pull stored objects from NSUserDefaults as dictionaries
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    
    NSError *e = nil;
    self.User = [[User alloc] initWithDictionary:dictUser error:&e];
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
    //NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:studentURL];
    //myRequest.timeoutInterval = 1.0;
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        // 3
        _transactionsDictionary = (NSDictionary *) responseObject;
        [self saveTransactions];
        
        [self.transactionTable reloadData];
        [_refreshControl endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"Error: %d", statusCode);
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"Time out brah");
        }
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
    if(![transactions.Status isEqual:@"V"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSString *formatedDate = [dateFormatter stringFromDate: transactions.TDate ];
        NSString *formattedAmount = [NSString stringWithFormat:@"%.2f", transactions.Amount];
        
        NSString *firstLine=[NSString stringWithFormat:@"%@%@%@",formatedDate,@" - ",transactions.TDesc];
        NSString *strAmount=[NSString stringWithFormat:@"%@%@",@"Amount - $ ",formattedAmount];
        
        self.selectedTransactionCell.descLabel.text = firstLine;
        [self.selectedTransactionCell.descLabel sizeToFit ];
        self.selectedTransactionCell.amountLabel.text = strAmount;
        
        if(transactions.Amount < 0)
            _selectedTransactionCell.amountLabel.textColor = [UIColor redColor];
        else
            _selectedTransactionCell.amountLabel.textColor = [UIColor blackColor];
    }
    
    return self.selectedTransactionCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat cellHeight = 0.0f;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountTransactionCell" owner:self options:nil];
    _selectedTransactionCell = [nib objectAtIndex:0];
    for(UIView* view in _selectedTransactionCell.subviews)
    {
        cellHeight += view.frame.size.height;
    }
    
    return cellHeight;
}


-(void) saveTransactions
{
    //triggered when all data is loaded
    NSError *e = nil;
    self.transactionsObject = [[NSMutableArray alloc] init];
    
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in _transactionsDictionary)
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

/**
 * Use the selected account and account transaction object to prefil the enter payment screen. This is done a little differently from 
 *other places where we switch view controllers b/c the user is selecting a transaction object from the table instead of selecting the
 * tabs at the bottom. So we instantiate the view controller based off of the tab bar controller and not the navigation controller. 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentViewController *paymentController = [self.tabBarController.viewControllers objectAtIndex:3];
    AccountTransactions *transaction = [self.transactionsObject objectAtIndex: indexPath.row];
    
    paymentController.selectedAccount = self.selectedAccount;
    paymentController.selectedAccountTransaction = transaction;
    paymentController.selectedACharge = YES;
    paymentController.delegate = self;
    NSError *error = nil;

    if([transaction.Type isEqual:@"Charge"])
    {
        if([transaction.Status isEqual:@"V"])
        {
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Void charge selected."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];

        }
        else if (transaction.Amount <= 0)
        {
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot pay a $0 or negative balance."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
        } else
        {
            [self.tabBarController setSelectedIndex:3];

        }
    }
}

/**
 * Switching inbetween tabs
 */
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
