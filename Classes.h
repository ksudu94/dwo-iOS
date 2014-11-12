//
//  Classes.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 11/12/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "JSONModel.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"


@interface Classes : JSONModel <RMMapping>


@property (assign, nonatomic) NSInteger SchID;
@property (assign, nonatomic) NSInteger SessionID;
@property (assign, nonatomic) NSInteger ClID;
@property (assign, nonatomic) NSString *ClNo;
@property (assign, nonatomic) NSString *ClType;
@property (assign, nonatomic) NSString *ClLevel;
@property (assign, nonatomic) NSString *ClRoom;
@property (assign, nonatomic) NSString *ClDay;
@property (assign, nonatomic) NSString *ClTime;
@property (assign, nonatomic) NSString *ClStart;
@property (assign, nonatomic) NSString *ClStop;
@property (assign, nonatomic) NSInteger ClLength;
@property (assign, nonatomic) NSInteger ClCur;
@property (assign, nonatomic) NSInteger ClMax;
@property (assign, nonatomic) NSInteger ClWait;
@property (assign, nonatomic) NSString *ClInstructor;
@property (assign, nonatomic) NSString *ClDescription;
@property (assign, nonatomic) float ClTuition;
@property (assign, nonatomic) NSInteger ClDayNo;
@property (assign, nonatomic) NSInteger ClLAge;
@property (assign, nonatomic) NSInteger ClUAge;
@property (assign, nonatomic) NSString *ClKey;
@property (assign, nonatomic) NSString *ClRequirements;
@property (assign, nonatomic) NSInteger ClTchID;
@property (assign, nonatomic) NSInteger ClAst1;
@property (assign, nonatomic) NSInteger ClAst2;
@property (assign, nonatomic) NSInteger ClAst3;
@property (assign, nonatomic) NSInteger ClAst4;
@property (assign, nonatomic) NSString *ClNotes;
@property (assign, nonatomic) NSString *ClSong1;
@property (assign, nonatomic) NSString *ClSong2;
@property (assign, nonatomic) NSString *ClSong3;
@property (assign, nonatomic) NSString *ClSong4;
@property (assign, nonatomic) NSString *ClSongLen1;
@property (assign, nonatomic) NSString *ClSongLen2;
@property (assign, nonatomic) NSString *ClSongLen3;
@property (assign, nonatomic) NSString *ClSongLen4;
@property (assign, nonatomic) BOOL ClOLReg;
@property (assign, nonatomic) NSInteger ClTypeID;
@property (assign, nonatomic) NSInteger ClLevelID;
@property (assign, nonatomic) NSInteger ClRoomID;
@property (assign, nonatomic) BOOL MultiDay;
@property (assign, nonatomic) BOOL Monday;
@property (assign, nonatomic) BOOL Tuesday;
@property (assign, nonatomic) BOOL Wednesday;
@property (assign, nonatomic) BOOL Thursday;
@property (assign, nonatomic) BOOL Friday;
@property (assign, nonatomic) BOOL Saturday;
@property (assign, nonatomic) BOOL Sunday;
@property (assign, nonatomic) NSInteger NoDays;
@property (assign, nonatomic) NSInteger TotalTime;

@end
