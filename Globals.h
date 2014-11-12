//
//  Globals.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject


- (NSDate*) getDateFromJSON:(NSString *)dateString;

-(NSMutableString *) buildURL:(NSMutableString *) methodName fromDictionary:(NSMutableDictionary *) dictionary;

@end
