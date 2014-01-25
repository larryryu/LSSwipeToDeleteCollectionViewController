//
//  LSTopCollectionViewController.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/17/14.
//  Copyright (c) 2014 Lukman Sanusi <egobooster@me.com>. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
