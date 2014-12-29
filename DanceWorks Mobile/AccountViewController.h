//
//  AccountViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface AccountViewController : UITableViewController

@property (atomic, retain) Account *selectedAccount;
@property (nonatomic, retain) UIBarButtonItem *rightBarButton;
@property (nonatomic, retain) UIBarButtonItem *leftBarButton;

-(void)LogOut: (id)sender;
@end
