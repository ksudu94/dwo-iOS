//
//  School.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 11/7/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface School : JSONModel <RMMapping>

@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger SStatus;
@property (assign, nonatomic) NSString *SRegNo;
@property (assign, nonatomic) NSInteger SessionID;
@property (assign, nonatomic) NSString *SContact;//
@property (assign, nonatomic) NSString *STaxID;//
@property (assign, nonatomic) NSString *SName;
@property (assign, nonatomic) NSString *SAddress;
@property (assign, nonatomic) NSString *SAddress2;
@property (assign, nonatomic) NSString *SCity;
@property (assign, nonatomic) NSString *SState;
@property (assign, nonatomic) NSString *SZip;
@property (assign, nonatomic) NSString *SPhone;
@property (assign, nonatomic) NSString *SFax;
@property (assign, nonatomic) NSString *SWebSite;
@property (assign, nonatomic) NSString *SEMail;
@property (assign, nonatomic) NSString *EMailSrvr;
@property (assign, nonatomic) NSString *EMailAcct;
@property (assign, nonatomic) NSString *EMailPwrd;
@property (assign, nonatomic) NSInteger EMailNotify;
@property (assign, nonatomic) NSInteger EMailPort;
@property (assign, nonatomic) NSInteger EMailSize;
@property (assign, nonatomic) NSString *EMailSig;
@property (assign, nonatomic) NSString *EMailCon;
@property (assign, nonatomic) NSString *EMailRec;
@property (assign, nonatomic) NSString *EMailReg;
@property (assign, nonatomic) NSString *EMailStm;
@property (assign, nonatomic) NSInteger MaxStudents;
@property (assign, nonatomic) NSString *DefaultCity;
@property (assign, nonatomic) NSString *DefaultState;
@property (assign, nonatomic) NSString *DefaultZip;
@property (assign, nonatomic) NSString *DefaultAreaCode;
@property (assign, nonatomic) NSString *PhoneMask;
@property (assign, nonatomic) BOOL DiscType;
@property (assign, nonatomic) float DiscAmount;
@property (assign, nonatomic) float DiscRound;
@property (assign, nonatomic) BOOL LateChgType;
@property (assign, nonatomic) float LateChgAmt;
@property (assign, nonatomic) float ClassTuition;
@property (assign, nonatomic) NSInteger ClassSizeMax;
@property (assign, nonatomic) NSInteger ClassLength;
@property (assign, nonatomic) BOOL ClassConflictChk;
@property (assign, nonatomic) NSInteger ClassSortOrder;
@property () NSDate *StudentGradeUpdate;
@property (assign, nonatomic) NSString *SPassword;
@property (assign, nonatomic) NSString *OPassword;
@property (assign, nonatomic) NSString *CPassword;
@property (assign, nonatomic) NSInteger AcctProg;
@property (assign, nonatomic) NSString *AcctLinkPath;
@property (assign, nonatomic) NSString *BankAcct;
@property (assign, nonatomic) NSString *CustDepAcct;
@property (assign, nonatomic) NSString *RefundAcct;
@property (assign, nonatomic) NSString *ARAcct;
@property (assign, nonatomic) NSString *DiscountAcct;
@property (assign, nonatomic) NSString *ST1Acct;
@property (assign, nonatomic) NSString *ST1Desc;
@property (assign, nonatomic) NSString *ST1Rate;
@property (assign, nonatomic) NSString *ST2Acct;
@property (assign, nonatomic) NSString *ST2Desc;
@property (assign, nonatomic) NSString *ST2Rate;
@property () NSDate *BackupDate;
@property (assign, nonatomic) NSString *BackupPath;
@property (assign, nonatomic) NSString *StatementNote;
@property (assign, nonatomic) NSString *PaymentTerms;
@property (assign, nonatomic) NSString *ConfirmNote;
@property (assign, nonatomic) NSString *RegistrationNote;
@property (assign, nonatomic) NSString *ReceiptNote;
@property (assign, nonatomic) NSString *CouponNote;
@property (assign, nonatomic) NSString *TaxCreditNote;
@property (assign, nonatomic) NSString *CostumeNote;
@property (assign, nonatomic) NSString *RConfirmNote;
@property (assign, nonatomic) NSInteger TuitionSelect;
@property (assign, nonatomic) BOOL BalFwd;
@property (assign, nonatomic) BOOL HideAcct;
@property (assign, nonatomic) NSInteger BackColor;
@property (assign, nonatomic) float RegStu01;
@property (assign, nonatomic) float RegStu02;
@property (assign, nonatomic) float RegStu03;

@property (assign, nonatomic) float RegStu04;
@property (assign, nonatomic) float RegStu05;
@property (assign, nonatomic) float RegStu06;
@property (assign, nonatomic) NSString *ShipName;
@property (assign, nonatomic) NSString *ShipAddr;
@property (assign, nonatomic) NSString *ShipAddr2;
@property (assign, nonatomic) NSString *ShipCity;
@property (assign, nonatomic) NSString *ShipState;
@property (assign, nonatomic) NSString *ShipZip;
@property (assign, nonatomic) NSString *ShipPhone;
@property (assign, nonatomic) NSString *CCProcessor;
@property (assign, nonatomic) NSString *CCUserName;
@property (assign, nonatomic) NSString *CCPassword;
@property (assign, nonatomic) NSInteger CCMerchantNo;
@property (assign, nonatomic) NSInteger CCBatchNo;
@property (assign, nonatomic) float CCMaxAmt;
@property (assign, nonatomic) NSInteger StmtType;
@property (assign, nonatomic) BOOL StmtSNames;
@property () NSDate *YearUpdate;
@property () NSDate *Closeout;
@property (assign, nonatomic) float Drawer;
@property (assign, nonatomic) NSString *OLPWord;
@property (assign, nonatomic) BOOL Receipt80;
@property (assign, nonatomic) NSString *ReturnPolicy;
@property (assign, nonatomic) BOOL CCAMEX;
@property (assign, nonatomic) BOOL CCDiscover;
@property (assign, nonatomic) BOOL CCMasterCard;
@property (assign, nonatomic) BOOL CCVisa;
@property (assign, nonatomic) NSString *DeclineMessage;
@property (assign, nonatomic) BOOL MCActive;
@property (assign, nonatomic) NSString *MCAPIString;
@property (assign, nonatomic) NSString *MCListID;
@property (assign, nonatomic) BOOL UseSchoolEmail;
@property (assign, nonatomic) NSString *MercuryUsername;
@property (assign, nonatomic) NSString *MercuryPassword;
@property (assign, nonatomic) NSInteger MercuryAVSCheck;
@property (assign, nonatomic) NSInteger MercuryCVVCheck;
@property (assign, nonatomic) NSString *LogoName;


@end
