//
//  AccountTransactions2.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 1/9/15.
//  Copyright (c) 2015 Akada Software. All rights reserved.
//

#import "AccountTransactions2.h"

@implementation AccountTransactions2

-(void) viewDidLoad
{
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    NSMutableArray *thirdSection = [[NSMutableArray alloc] init];
    NSMutableArray *fourthSection = [[NSMutableArray alloc] init];

    for (int i=0; i<50; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"First %d", i]];
        [secondSection addObject:[NSString stringWithFormat:@"Second %d", i]];
        [thirdSection addObject:[NSString stringWithFormat:@"Third %d", i]];
        [fourthSection addObject:[NSString stringWithFormat:@"Fourth %d", i]];

    }
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, secondSection, thirdSection, fourthSection, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"CellView" bundle:nil];
    [self.transCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.transCollectionView setCollectionViewLayout:flowLayout];
    
    
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataArray count];
    //return 4;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    
    //return [sectionArray count];
    return 4;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
    NSString *cellData = [data objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cvCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
    [titleLabel setText:cellData];
    
    return cell;
}
@end
