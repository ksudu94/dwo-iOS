//
//  AccountInformation.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@interface AccountInformation : UIViewController <UITabBarDelegate>

@property (atomic, retain) Account *selectedAccount;
@property (weak, nonatomic) IBOutlet UITabBar *accountTabBar;
@end
