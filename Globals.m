//
//  Globals.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "Globals.h"
#import "School.h"
#import "Session.h"
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
    NSDate *formattedDate = [NSDate dateWithTimeIntervalSince1970:interval];
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:formattedDate];
    //NSDate *dateWithoutTime = [[NSCalendar currentCalendar] dateFromComponents:components];
    return formattedDate;
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

//For urls with special characters. 
-(NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) getTime {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    return  dateString;
}

-(NSString *) textField:(UITextField*)textField formatAmountCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    //Max length for amount for payment
    #define MAX_LENGTH 8

    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"GBP"];
    int maximumFractionDigits = numberFormatter.maximumFractionDigits;
    NSString * decimalSeparator = numberFormatter.decimalSeparator;

    // get current cursor position
    UITextRange* selectedRange = [textField selectedTextRange];
    UITextPosition* start = textField.beginningOfDocument;
    NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
    
    // Update the string in the text input
    NSMutableString* currentString = [NSMutableString stringWithString:textField.text];
    NSUInteger currentLength = currentString.length;
    [currentString replaceCharactersInRange:range withString:string];
    
    // Strip out the decimal separator
    [currentString replaceOccurrencesOfString:decimalSeparator withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [currentString length])];
    
    // Generate a new string for the text input
    int currentValue = [currentString intValue];
    NSString* format = [NSString stringWithFormat:@"%%.%df", maximumFractionDigits];
    double minorUnitsPerMajor = pow(10, maximumFractionDigits);
    NSString* newString = [[NSString stringWithFormat:format, currentValue / minorUnitsPerMajor] stringByReplacingOccurrencesOfString:@"." withString:decimalSeparator];
    
    if (newString.length <= MAX_LENGTH) {
        textField.text = newString;
        
        // if the cursor was not at the end of the string being entered, restore cursor position
        if (cursorOffset != currentLength) {
            int lengthDelta = newString.length - currentLength;
            int newCursorOffset = MAX(0, MIN(newString.length, cursorOffset + lengthDelta));
            UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
            UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
            [textField setSelectedTextRange:newRange];
        }
    }
    return newString;
    
}

-(int) getCurrentSessionPosition: (NSMutableArray *) sessionArray forSchool:(School *)selectedSchool
{
    for (int position = 0; position < sessionArray.count; position++)
    {
        
        Session *currentSession = [sessionArray objectAtIndex:position];
        if (currentSession.SessionID == selectedSchool.SessionID)
        {
           return position;
        }
    }
    return 0;
}
@end
