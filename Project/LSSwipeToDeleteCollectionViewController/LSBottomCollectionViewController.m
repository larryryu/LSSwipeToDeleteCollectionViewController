//
//  LSBottomCollectionViewController.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import "LSBottomCollectionViewController.h"

NSString *const LSBottomCollectionViewCellIdentifier = @"bottomCell";

@interface LSBottomCollectionViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation LSBottomCollectionViewController

+ (UICollectionViewLayout *) defaultCollectionViewLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return flowLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LSBottomCollectionViewCellIdentifier];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LSBottomCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor greenColor]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = self.collectionView.bounds.size;
    size.width = 100.0f;
    size.height -= 10.0f;
    return size;
}

@end
