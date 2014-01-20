//
//  LSTopCollectionViewController.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/17/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import "LSTopCollectionViewController.h"

@interface LSTopCollectionViewController () <UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *colors;
}
@end

@implementation LSTopCollectionViewController

+ (UICollectionViewLayout *) defaultCollectionViewLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return flowLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setClipsToBounds:NO];
    [self resetColors];
}

-(void)resetColors{
    colors = @[[UIColor redColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor]].mutableCopy;
}

#pragma mark - UICollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // if you dont call super, set the scrollViewDelegate of LSScrollViewCell or its subclass to self
    LSScrollViewCell *cell = (LSScrollViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.scrollViewContentView setBackgroundColor:colors[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = self.collectionView.bounds.size;
    size.width = 200.0f;
    size.height -= 20.0f;
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insects = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
    return insects;
}

-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller didDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
    [colors removeObjectAtIndex:indexPath.row];
}

-(BOOL)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller canDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

@end
