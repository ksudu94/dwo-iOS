//
//  User.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel
{
    
}


@property (assign, nonatomic) int SchID;
@property (assign, nonatomic) int UserID;
@property (assign, nonatomic) NSString *UserName;
@property (assign, nonatomic) NSString *EMailAddr;
@property (assign, nonatomic) BOOL Admin;
@property (assign, nonatomic) NSString *Access;
@property (assign, nonatomic) BOOL ProcReg;
@property (assign, nonatomic) NSString *DisplayName;
@property (assign, nonatomic) BOOL TransTypeOptions;
@property (assign, nonatomic) int TransType;
@property (assign, nonatomic) int TransPaymentKind;
@property (assign, nonatomic) int TransChargeKind;
@property (assign, nonatomic) BOOL TransDateOptions;
@property () NSDate *TransStartDate;
@property () NSDate *TransEndDate;
@property (assign, nonatomic) int TransDeleted;
@property (assign, nonatomic) BOOL StudentOptions;
@property (assign, nonatomic) int StudentSort;
@property (assign, nonatomic) int StudentSelection;
@property (assign, nonatomic) int StudentsShown;
@property (assign, nonatomic) int StudentGroupCode;
@property (assign, nonatomic) BOOL AccountOptions;
@property (assign, nonatomic) int AccountSort;
@property (assign, nonatomic) int AccountSelection;
@property (assign, nonatomic) int AccountsShown;
@property (assign, nonatomic) int AccountGroupCode;
@property (assign, nonatomic) BOOL ClassOptions;
@property (assign, nonatomic) int ClassSort;
@property (assign, nonatomic) int ClassesShown;
@property (assign, nonatomic) BOOL StaffOptions;
@property (assign, nonatomic) int StaffSort;
@property (assign, nonatomic) int StaffShown;
@property (assign, nonatomic) BOOL ShowNotes;
@property (assign, nonatomic) BOOL ShowTransactions;
@property (assign, nonatomic) BOOL ShowRegistrations;
@property (assign, nonatomic) int AccountListSize;
@property (assign, nonatomic) int StudentListSize;
@property (assign, nonatomic) int ClassListSize;
@property (assign, nonatomic) int StaffListSize;
@property (assign, nonatomic) NSString *UserGUID;
@property (assign, nonatomic) int StaffID;

@end