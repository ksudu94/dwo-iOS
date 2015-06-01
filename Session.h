//
//  Student.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 5-20-2015
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface Session : JSONModel <RMMapping>

@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger SessionID;
@property (assign, nonatomic) NSString *SessionName;
@property () NSDate *SessionDate;
@property () NSDate *SDate;
@property () NSDate *EDate;
@property (assign, nonatomic) BOOL DisplaySession;

@end
