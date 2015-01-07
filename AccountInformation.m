//
//  AccountInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/1/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "AccountInformation.h"
#import "Account.h"
#import "AccountViewController.h"
#import "AccountStudentController.h"


@implementation AccountInformation
{

    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *txtCardNumber;
    IBOutlet UILabel *txtCardType;
    IBOutlet UILabel *txtEmail;
    IBOutlet UILabel *txtPhone;
    IBOutlet UILabel *txtStatus;
    IBOutlet UILabel *txtAddress;
    IBOutlet UILabel *txtName;
    //IBOutlet UITabBarItem *tbAcount;
}


-(void) viewDidLoad
{
    [super viewDidLoad];
    //[self accountTabBar: self.accountTabBar didSelectItem: [self.accountTabBar.items firstObject]];
    self.accountTabBar.selectedItem = [self.accountTabBar.items firstObject];
    CGFloat scrollViewHeight = 0.0f;
    
    for(UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [scrollView setContentSize:(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height))];
    scrollView.frame = self.view.frame;
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",self.selectedAccount.FName,@" ",self.selectedAccount.LName];

    switch (self.selectedAccount.Status)
    
    {
        case 0:
            txtStatus.text = @"Active";
            break;
        case 1:
            txtStatus.text = @"Inactive";
            break;
        case 2:
            txtStatus.text = @"Prospect";
            break;
        case 3:
            txtStatus.text = @"Deleted";
            break;
        default:
            txtStatus.text = @"Something";
            break;
            
    }
    
    switch (self.selectedAccount.CCType)
    
    {
        case 1:
            txtCardType.text = @"AMEX:";
            break;
        case 2:
            txtCardType.text = @"Discover:";
            break;
        case 3:
            txtCardType.text = @"MC:";
            break;
        case 4:
            txtCardType.text = @"VISA:";
            break;
        default:
            txtCardType.text = @"Error:";
            break;
            
    }
    NSString *cardTrail=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",self.selectedAccount.CCFName,@" ",self.selectedAccount.CCLName, @"-", self.selectedAccount.CCTrail, @"-", @"Exp. ",self.selectedAccount.CCExpire];


    txtName.text = fullName;
    txtEmail.text = self.selectedAccount.EMail;
    txtPhone.text = self.selectedAccount.Phone;
    txtAddress.text = self.selectedAccount.Address;
    txtCardNumber.text = cardTrail;
    
    
   }

-(void) tabBar:(UITabBar *) tabBar didSelectItem:(UITabBarItem *)item
{
    //This breaks if it is inside one of the cases
    AccountStudentController *controller = nil;

    switch(item.tag)
    {
        case 1:
            NSLog(@"%d", item.tag);
            break;
        case 2:
            controller = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"AccountStudents"];
            controller.selectedAccount = self.selectedAccount;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        case 3:
            NSLog(@"%d", item.tag);
            break;
        case 4:
            NSLog(@"%d", item.tag);
            break;
        case 5:
            NSLog(@"%d", item.tag);
            break;
          
            
    }
    
}

@end
