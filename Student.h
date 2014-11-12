//
//  Student.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 11/12/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface Student : JSONModel <RMMapping>

@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger StuID;
@property (assign, nonatomic) NSString *StuNo;
@property (assign, nonatomic) NSString *ScanKey;
@property (assign, nonatomic) NSInteger AcctID;
@property (assign, nonatomic) NSString *AcctNo;
@property (assign, nonatomic) NSString *LName;
@property (assign, nonatomic) NSString *FName;
@property (assign, nonatomic) NSString *Address;
@property (assign, nonatomic) NSString *City;
@property (assign, nonatomic) NSString *State;
@property (assign, nonatomic) NSString *ZipCode;
@property (assign, nonatomic) NSString *Phone;
@property (assign, nonatomic) NSString *Cell;
@property (assign, nonatomic) NSString *EMail;
@property (assign, nonatomic) NSString *SSN;
@property (assign, nonatomic) NSInteger Status;
@property () NSDate *DateReg;
@property () NSDate *InactiveDate;
@property (assign, nonatomic) NSInteger TuitionSel;
@property (assign, nonatomic) BOOL Gender;
@property (assign, nonatomic) BOOL Discount;
@property () NSDate *BirthDate;
@property (assign, nonatomic) NSString *School;
@property (assign, nonatomic) NSString *Grade;
@property (assign, nonatomic) NSString *YearStarted;
@property (assign, nonatomic) NSInteger YearsAtSchool;
@property (assign, nonatomic) NSString *AcctName;
@property (assign, nonatomic) NSInteger NoClasses;
@property (assign, nonatomic) float MTuition;
@property (assign, nonatomic) NSInteger ClassTime;
@property (assign, nonatomic) float Bust;
@property (assign, nonatomic) float Hips;
@property (assign, nonatomic) float Waist;
@property (assign, nonatomic) float Inseam;
@property (assign, nonatomic) float Girth;
@property (assign, nonatomic) NSString *DrName;
@property (assign, nonatomic) NSString *DrPhone;
@property (assign, nonatomic) NSString *Allergies;
@property (assign, nonatomic) NSString *OtherMed;
@property (assign, nonatomic) NSString *PicturePath;
@property (assign, nonatomic) NSString *Notes;
@property (assign, nonatomic) NSString *StudentFee;
@property (assign, nonatomic) float StudentFeeAmount;
@property (assign, nonatomic) NSInteger CardUses;
@property () NSDate *CardExpire;
@property (assign, nonatomic) NSInteger CardClass1;
@property (assign, nonatomic) NSInteger CardClass2;


@end
