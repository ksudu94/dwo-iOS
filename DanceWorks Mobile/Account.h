//
//  Account.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/10/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface Account : JSONModel <RMMapping>
{
    //Generally for instance variables but those will be stored in .m file
}


//Declares public property as well as wether to store a copy or a pointer of this variable in the model
/* Properties
 *Copy - Required when object is mutuable. Creates a copy of it to be changed;
 *Assign - used for primitive types. Returns a reference to the object
 */
@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger AcctID;
@property (assign, nonatomic) NSString *AcctNo;
@property (copy, nonatomic) NSString *FName;
@property (copy, nonatomic) NSString *LName;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *City;
@property (copy, nonatomic) NSString *State;
@property (copy, nonatomic) NSString *ZipCode;
@property (copy, nonatomic) NSString *Phone;
@property (copy, nonatomic) NSString *EMail;
@property () NSDate *DateReg;
@property () NSDate *InactiveDate;
@property (assign, nonatomic) NSInteger Status;
@property (assign, nonatomic) NSInteger BillingFreq;
@property (assign, nonatomic) float Balance;
@property () NSDate *LastPmtDate;
@property (assign, nonatomic) float LastPmtAmt;
@property (assign, nonatomic) float NoStudents;
@property (assign, nonatomic) NSInteger TuitionSel;
@property (assign, nonatomic) NSString *Alert;
@property (assign, nonatomic) NSString *Source;
@property (assign, nonatomic) float MTuition;
@property (assign, nonatomic) NSInteger ClassTime;
@property (assign, nonatomic) NSString *P1Name;
@property (assign, nonatomic) NSString *P1EMail;
@property (assign, nonatomic) NSString *P1Phone;
@property (assign, nonatomic) NSString *P1Cell;
@property (assign, nonatomic) NSString *P1Work;
@property (assign, nonatomic) NSString *P2Name;
@property (assign, nonatomic) NSString *P2EMail;
@property (assign, nonatomic) NSString *P2Phone;
@property (assign, nonatomic) NSString *P2Cell;
@property (assign, nonatomic) NSString *P2Work;
/*@property (assign, nonatomic) NSString *P3Name;
 @property (assign, nonatomic) NSString *P3EMail;
 @property (assign, nonatomic) NSString *P3Phone;
 @property (assign, nonatomic) NSString *P3Cell;
 @property (assign, nonatomic) NSString *P3Work;
 @property (assign, nonatomic) NSString *P4Name;
 @property (assign, nonatomic) NSString *P4EMail;
 @property (assign, nonatomic) NSString *P4Phone;
 @property (assign, nonatomic) NSString *P4Cell;
 @property (assign, nonatomic) NSString *P4Work;*/
@property (assign, nonatomic) NSInteger CCType;
@property (assign, nonatomic) NSString *CCTrail;
@property (assign, nonatomic) NSString *CCExpire;
@property (assign, nonatomic) NSString *CCFName;
@property (assign, nonatomic) NSString *CCLName;
@property (assign, nonatomic) NSString *CCAddress;
@property (assign, nonatomic) NSString *CCCity;
@property (assign, nonatomic) NSString *CCState;
@property (assign, nonatomic) NSString *CCZip;
@property (assign, nonatomic) NSInteger CCConsentID;
@property (assign, nonatomic) BOOL CCMonthly;
@property (assign, nonatomic) NSInteger CCDate;
@property (assign, nonatomic) NSString *Notes;
@property (assign, nonatomic) NSString *AccountFee;
@property (assign, nonatomic) float AccountFeeAmount;
@property (assign, nonatomic) NSString *AcctPWord;
@property (assign, nonatomic) BOOL OLReg;
@property (assign, nonatomic) BOOL AgreePol;
@property (assign, nonatomic) BOOL RequireCreditCard;
@property (assign, nonatomic) BOOL Complete;
@property (assign, nonatomic) NSString *ResetString;
@property (assign, nonatomic) BOOL Activated;
@property (assign, nonatomic) BOOL UsesNewPassword;
@property (assign, nonatomic) NSInteger AlertID;
@property (assign, nonatomic) NSInteger SourceID;
@property (assign, nonatomic) BOOL Subscribed;
@property (assign, nonatomic) NSString *CCToken;

- (NSDate*) getDateFromJSON:(NSString *)dateString;


@end
