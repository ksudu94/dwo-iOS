//
//  AccountTransactions2.h
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/9/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTransactions2 : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *transCollectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end
