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
@property (copy, nonatomic) NSString *FName;
@property (copy, nonatomic) NSString *LName;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *City;
@property (copy, nonatomic) NSString *State;
@property (copy, nonatomic) NSString *ZipCode;
@property (copy, nonatomic) NSString *Phone;
@property (copy, nonatomic) NSString *Cell;
@property (copy, nonatomic) NSString *EMail;
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
@property (copy, nonatomic) NSString *AcctName;
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
