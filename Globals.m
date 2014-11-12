//
//  Globals.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "Globals.h"


@implementation Globals

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

-(NSMutableString *) buildURL:(NSMutableString *) methodName fromDictionary:(NSMutableDictionary *) dictionary
{
    NSMutableString * jsonURL = [[NSMutableString alloc] init];
    [jsonURL setString:@"http://app.akadasoftware.com/ws/Service1.svc/"];

    [jsonURL appendString: methodName];
    for(id key in dictionary)
    {
        [jsonURL appendString:key];
        [jsonURL appendString:@"="];
        [jsonURL appendString:[dictionary objectForKey:key]];
        [jsonURL appendString:@"&"];
    }
    [jsonURL deleteCharactersInRange:NSMakeRange([jsonURL length]-1, 1)];
    return jsonURL;
}

@end
