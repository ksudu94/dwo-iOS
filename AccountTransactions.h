//
//  AccountTransactions.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/9/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface AccountTransactions : JSONModel <RMMapping>


@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger TID;
@property (assign, nonatomic) NSInteger TNo;
@property (assign, nonatomic) NSInteger AcctID;
@property () NSDate *TDate;
@property (assign, nonatomic) NSString *TDesc;
@property (assign, nonatomic) NSString *GLNo;
@property (assign, nonatomic) NSString *ChkNo;
@property (assign, nonatomic) float Amount;
@property (assign, nonatomic) float Balance;
@property (assign, nonatomic) float STax1;
@property (assign, nonatomic) float STax2;
@property (assign, nonatomic) NSString *Status;
@property (assign, nonatomic) NSString *Type;
@property (assign, nonatomic) NSString *Kind;
@property (assign, nonatomic) NSString *CCard;
@property (assign, nonatomic) NSString *CCDate;
@property (assign, nonatomic) NSString *CCAuth;
@property (assign, nonatomic) NSString *CCRecNo;
@property (assign, nonatomic) BOOL POSTrans;
@property (assign, nonatomic) NSInteger POSInv;
@property (assign, nonatomic) BOOL Closed;
@property (assign, nonatomic) BOOL PayOnline;
@property (assign, nonatomic) NSInteger TransPostHistID;
@property (assign, nonatomic) NSInteger SessionID;
@property (assign, nonatomic) float DiscAmt;
@property (assign, nonatomic) NSInteger ConsentID;
@property (assign, nonatomic) NSString *PaymentID;
@property (assign, nonatomic) NSString *ProcessData;
@property (assign, nonatomic) NSString *RefNo;
@property (assign, nonatomic) NSString *AuthCode;
@property (assign, nonatomic) NSString *Invoice;
//@property (assign, nonatomic) NSString *AcqRefData;
@property (assign, nonatomic) NSString *CardHolderName;
//@property (assign, nonatomic) NSString *CCToken;
//@property (assign, nonatomic) NSString *EvoTransactionId;
//@property (assign, nonatomic) NSString *EvoApprovalCode;
//@property (assign, nonatomic) NSString *EvoBatchId;
//@property (assign, nonatomic) NSString *EvoServiceTransactionId;


@end
