//
//  AccountInformation.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "AccountStudentController.h"
#import "AccountTransactions.h"
#import "EditAccountInformationController.h"
@interface AccountInformation : UIViewController <UITabBarControllerDelegate, UIPageViewControllerDataSource, EditAccountInformationControllerDelegate>

@property (nonatomic, retain) Account *selectedAccount;

@property (nonatomic, retain) AccountStudentController *accountStudentsController;
@property (nonatomic, retain) AccountTransactions *accountTransactionsController;
@property (strong, nonatomic) UIPageViewController *pageController;
-(void) setAccountFields;


@end
