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
#import "AccountTransactionsController.h"
#import "EditAccountInformationController.h"
#import "EditCreditCardInformation.h"
#import "PaymentViewController.h"
#import "ChargeViewController.h"


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
}

- (IBAction)editAccountInformation:(id)sender
{
    EditAccountInformationController *editController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EditAccountInformation"];
    editController.selectedAccount = self.selectedAccount;
    editController.delegate = self;
    

    [[self navigationController] pushViewController:editController animated:YES];
}

- (IBAction)editCreditCardInformation:(id)sender
{
    EditCreditCardInformation *editCreditCardController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EditCreditCardInformation"];
    
    editCreditCardController.selectedAccount = self.selectedAccount;
    //editCreditCardController.delegate = self;
    
    
    [[self navigationController] pushViewController:editCreditCardController animated:YES];
}


-(void) addItemViewController:(EditAccountInformationController *)controller didFinishEnteringItem:(Account *)editedAccount
{
    self.selectedAccount = editedAccount;
    [self setAccountFields];
}



-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    CGFloat scrollViewHeight = 0.0f;
    
    for(UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [scrollView setContentSize:(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height))];
    scrollView.frame = self.view.frame;
    [self setAccountFields];
    
}


-(void) setAccountFields
{
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
