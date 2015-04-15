//
//  AccountTransactionsController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/8/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "User.h"
#import "Account.h"
#import "AccountTransactions.h"
#import "AccountTransactionsCell.h"
#import "PaymentViewController.h"

@interface AccountTransactionsController : UIViewController < UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, PaymentViewControllerDelegate>


@property (nonatomic, retain) Account *selectedAccount;
@property (nonatomic, strong) User *User;
@property (nonatomic, strong) Globals *oGlobals;
@property (nonatomic, strong) AccountTransactions *selectedAccountTransaction;
@property (nonatomic, strong) AccountTransactionsCell *selectedTransactionCell;

@property (weak, nonatomic) IBOutlet UITableView *transactionTable;

@property (nonatomic, strong) NSMutableArray *transactionsObject;
@property (nonatomic, strong) NSDictionary *data;

@end


