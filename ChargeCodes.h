//
//  ChargeCodes.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/24/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"


@interface ChargeCodes: JSONModel <RMMapping>

@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger ChgID;
@property (copy, nonatomic) NSString *ChgNo;
@property (assign, nonatomic) NSString *GLNo;
@property (assign, nonatomic) NSString *ChgDesc;
@property (assign, nonatomic) NSString *Kind;
@property (assign, nonatomic) float Amount;
@property (assign, nonatomic) NSInteger Tax;
@property (assign, nonatomic) BOOL PayOnline;
@property (assign, nonatomic) BOOL TaxCredit;

@end