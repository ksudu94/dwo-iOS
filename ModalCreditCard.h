//
//  ModalCreditCard.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/13/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalCreditCard : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *creditCardView;
@property (strong, nonatomic) IBOutlet UIButton *lbCancel;

@property (nonatomic, assign) id currentResponder;

@property (strong, nonatomic) IBOutlet UITextField *tfCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfCVV;
@property (strong, nonatomic) IBOutlet UITextField *tfExpireDate;

@property(atomic, strong) NSString* CardNumber;
@property(atomic, strong) NSString* CardCVV;
@property(atomic, strong) NSString* CardDate;

@end
