//
//  Globals.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "School.h"

@interface Globals : NSObject <UITextFieldDelegate>


- (NSDate*) getDateFromJSON:(NSString *)dateString;

-(NSMutableString *) buildURL:(NSMutableString *) methodName fromDictionary:(NSMutableDictionary *) dictionary;

-(NSString *) URLEncodeString:(NSString *) str;

- (NSString *) getTime;

-(NSString *) textField:(UITextField*)textField formatAmountCharactersInRange:(NSRange)range replacementString:(NSString*)string;

-(int) getCurrentSessionPosition: (NSMutableArray *) sessionArray forSchool:(School *)selectedSchool;

@end
