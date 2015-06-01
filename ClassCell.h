//
//  ClassCell.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 5/28/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbEnrollmentStatus;
@property (nonatomic, weak) IBOutlet UILabel *lbClassType;
@property (nonatomic, weak) IBOutlet UILabel *lbClassDescription;
@property (nonatomic, weak) IBOutlet UILabel *lbClassTime;
@property (nonatomic, weak) IBOutlet UILabel *lbCassInstructor;
@end
