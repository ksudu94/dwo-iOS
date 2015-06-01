//
//  User.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface User : JSONModel <RMMapping>
    
@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger UserID;
@property (copy, nonatomic) NSString *UserGUID;
@property (assign, nonatomic) NSString *UserName;
@property (assign, nonatomic) NSString *EMailAddr;
@property (assign, nonatomic) BOOL Admin;
@property (assign, nonatomic) NSString *Access;
@property (assign, nonatomic) BOOL ProcReg;
@property (copy, nonatomic) NSString *DisplayName;
@property (assign, nonatomic) BOOL TransTypeOptions;
@property (assign, nonatomic) NSInteger TransType;
@property (assign, nonatomic) NSInteger TransPaymentKind;
@property (assign, nonatomic) NSInteger TransChargeKind;
@property (assign, nonatomic) BOOL TransDateOptions;
@property () NSDate *TransStartDate;
@property () NSDate *TransEndDate;
@property (assign, nonatomic) NSInteger TransDeleted;
@property (assign, nonatomic) BOOL StudentOptions;
@property (assign, nonatomic) NSInteger StudentSort;
@property (assign, nonatomic) NSInteger StudentSelection;
@property (assign, nonatomic) NSInteger StudentsShown;
@property (assign, nonatomic) NSInteger StudentGroupCode;
@property (assign, nonatomic) BOOL AccountOptions;
@property (assign, nonatomic) NSInteger AccountSort;
@property (assign, nonatomic) NSInteger AccountSelection;
@property (assign, nonatomic) NSInteger AccountsShown;
@property (assign, nonatomic) NSInteger AccountGroupCode;
@property (assign, nonatomic) BOOL ClassOptions;
@property (assign, nonatomic) NSInteger ClassSort;
@property (assign, nonatomic) NSInteger ClassesShown;
@property (assign, nonatomic) BOOL StaffOptions;
@property (assign, nonatomic) NSInteger StaffSort;
@property (assign, nonatomic) NSInteger StaffShown;
@property (assign, nonatomic) BOOL ShowNotes;
@property (assign, nonatomic) BOOL ShowTransactions;
@property (assign, nonatomic) BOOL ShowRegistrations;
@property (assign, nonatomic) NSInteger AccountListSize;
@property (assign, nonatomic) NSInteger StudentListSize;
@property (assign, nonatomic) NSInteger ClassListSize;
@property (assign, nonatomic) NSInteger StaffListSize;
@property (assign, nonatomic) NSInteger StaffID;

@end