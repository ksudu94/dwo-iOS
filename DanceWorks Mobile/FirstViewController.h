//
//  FirstViewController.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/10/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface FirstViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *textField;
-(IBAction)textFieldReturn:(id)sender;

@end

