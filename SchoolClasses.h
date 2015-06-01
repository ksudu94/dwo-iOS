//
//  SchoolClasses.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/27/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//


#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface SchoolClasses : JSONModel <RMMapping>


@property (assign, nonatomic) NSInteger ClID;

@property (assign, nonatomic) NSString *ClType;

@property (assign, nonatomic) NSString *ClLevel;

@property (assign, nonatomic) NSString *ClRoom;

@property (assign, nonatomic) NSString *ClDay;

@property (assign, nonatomic) NSString *ClDescription;

@property (assign, nonatomic) NSString *ClStart;

@property (assign, nonatomic) NSString *ClStop;

@property (assign, nonatomic) NSString *ClTime;

@property (assign, nonatomic) NSString *ClInstructor;

@property (assign, nonatomic) float ClTuition;

@property (assign, nonatomic) NSInteger ClLength;

@property (assign, nonatomic) NSInteger ClTchID;

@property (assign, nonatomic) BOOL Multiday;

@property (assign, nonatomic) BOOL Monday;

@property (assign, nonatomic) BOOL Tuesday;

@property (assign, nonatomic) BOOL Wednesday;

@property (assign, nonatomic) BOOL Thursday;

@property (assign, nonatomic) BOOL Friday;

@property (assign, nonatomic) BOOL Saturday;

@property (assign, nonatomic) BOOL Sunday;

@property (assign, nonatomic) NSInteger ClLAge;

@property (assign, nonatomic) NSInteger ClUAge;

@property (assign, nonatomic) NSString *ClKey;

@property (assign, nonatomic) NSInteger ClCur;

@property (assign, nonatomic) NSInteger ClMax;

@property (assign, nonatomic) NSString *ClWait;

@property (assign, nonatomic) NSString *ClDayNo;

@property (assign, nonatomic) NSInteger SessionID;

@property (assign, nonatomic) NSInteger ClRID;

@property (assign, nonatomic) NSInteger WaitID;

@property (assign, nonatomic) NSInteger EnrollmentStatus;

@end
