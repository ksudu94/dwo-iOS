//
//  StudentWaitList.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 4/24/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface StudentWaitList : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(atomic, strong) NSString* strSession;
@property (atomic, retain) NSArray *sessionArray;
@property (nonatomic, strong) Globals *oGlobals;





@end
