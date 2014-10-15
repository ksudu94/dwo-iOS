//
//  Account.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/10/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//
#import "Account.h"
#import "JSONModel.h"

@implementation Account


- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    //NSLog(@"%llu",milliseconds);
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}
@end