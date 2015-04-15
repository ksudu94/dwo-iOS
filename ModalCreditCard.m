//
//  ModalCreditCard.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/13/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "ModalCreditCard.h"

@interface ModalCreditCard ()

@end

@implementation ModalCreditCard

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)cancelNewCard:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveNewCard:(id)sender
{
    
    NSError *error = nil;
    if([self.tfCardNumber.text isEqualToString:@""] || [self.tfCVV.text isEqualToString:@""]|| [self.tfExpireDate .text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error, no blank fields allowed."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        UIAlertView *invalidCreditCard = [[UIAlertView alloc] initWithTitle:@"Invalid credit card number."
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
        
        
        _CardNumber = _tfCardNumber.text;
        int cardNumberLength = _CardNumber.length;
        _CardCVV = _tfCVV.text;
        int CVVLength = _CardCVV.length;
        NSString *firstCharacter = [_CardNumber substringToIndex:1];
        int firstDigit = [firstCharacter integerValue];
        
        if(cardNumberLength > 0)
        {
            switch (firstDigit) {
                case 3:
                    if(cardNumberLength == 15 && CVVLength == 4)
                    {
                        [self validateDate];
                    }
                    break;
                case 4:
                    if( (cardNumberLength == 13 || cardNumberLength == 16) && CVVLength == 3)
                    {
                        [self validateDate];
                        
                    }
                    break;
                case 5:
                    if(cardNumberLength == 16 && CVVLength == 3)
                    {
                        [self validateDate];
                        
                    }
                    break;
                case 6:
                    if(cardNumberLength == 16 && CVVLength == 3)
                    {
                        [self validateDate];
                        
                    }
                    break;
                default:
                    [invalidCreditCard show];
                    break;
            }
        }
        else
        {
            [invalidCreditCard show];
            
        }

    }
   

}

-(void) validateDate
{
    _CardDate = self.tfExpireDate.text;
    int cardNumberLength = _CardDate.length;
    NSString *firstCharacter = [_CardDate substringToIndex:1];
    int firstDigit = [firstCharacter integerValue];
    BOOL validDate = NO;
    
    NSError* error = nil;
    UIAlertView *invalidExpireDate = [[UIAlertView alloc] initWithTitle:@"Invalid Expiration Date."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
    if(!firstDigit == 0)
    {
        if(cardNumberLength == 4)
        {
            validDate = YES;
        }
        else
        {
            [invalidExpireDate show];
        }
    }
    else
    {
        if(cardNumberLength == 3)
        {
            validDate = YES;
        }
        else
        {
            [invalidExpireDate show];
        }
    }
    
    if(validDate)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_tfCardNumber resignFirstResponder];
    [_tfCVV resignFirstResponder];
    [_tfExpireDate resignFirstResponder];
}


@end
