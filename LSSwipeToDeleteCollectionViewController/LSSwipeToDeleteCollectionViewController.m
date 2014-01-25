//
//  LSTopCollectionViewController.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
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

#import <UIKit/UIKit.h>
#import "LSSwipeToDeleteCollectionViewController.h"

NSString *const LSSwipeToDeleteCollectionViewControllerCellIdentifier = @"LSSwipeToDeleteCollectionViewControllerCell";

@interface LSSwipeToDeleteCollectionViewController () <LSScrollViewCellDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *swipeToDeleteCollectionViewLayout;
@end

@implementation LSSwipeToDeleteCollectionViewController

-(id)init{
    self = [super init];
    if (self) {
        [self setUpDefaults];
    }
    return self;
}

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self setUpDefaults];
    }
    return self;
}

-(void)setUpDefaults{
    self.swipeToDeleteDirection = LSSwipeToDeleteDirectionMin;
    self.deletionVelocityTresholdValue = LSSwipeToDeleteCollectionViewControllerDefaultDeletionDistanceTresholdValue;
    self.deletionDistanceTresholdValue = LSSwipeToDeleteCollectionViewControllerDefaultDeletionVelocityTresholdValue;
    self.swipeToDeleteDelegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[LSScrollViewCell class] forCellWithReuseIdentifier:LSSwipeToDeleteCollectionViewControllerCellIdentifier];
    self.swipeToDeleteCollectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSScrollViewCell *cell = (LSScrollViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LSSwipeToDeleteCollectionViewControllerCellIdentifier forIndexPath:indexPath];
    cell.scrollViewDelegate = self;
    return cell;
}

- (LSScrollViewInsectType )insectTypeForScrollViewCell:(LSScrollViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    LSScrollViewInsectType insectType = LSScrollViewInsectTypeNone;
    
    if ([self.swipeToDeleteDelegate respondsToSelector:@selector(swipeToDeleteViewController:canDeleteCellAtIndexPath:)]) {
        if (![self.swipeToDeleteDelegate swipeToDeleteViewController:self canDeleteCellAtIndexPath:indexPath]) {
            return insectType;
        }
    }
    
    if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.swipeToDeleteDirection == LSSwipeToDeleteDirectionMin) {
            insectType |= LSScrollViewInsectTypeRight;
        }
        if (self.swipeToDeleteDirection == LSSwipeToDeleteDirectionMax){
            insectType |= LSScrollViewInsectTypeLeft;
        }
    }else if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        if (self.swipeToDeleteDirection == LSSwipeToDeleteDirectionMin) {
            insectType |= LSScrollViewInsectTypeBottom;
        }
        if (self.swipeToDeleteDirection == LSSwipeToDeleteDirectionMax){
            insectType |= LSScrollViewInsectTypeTop;
        }
    }
    return insectType;
}

-(void)scrollViewCell:(LSScrollViewCell *)cell scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:cell];
    
    LSSwipeToDeleteDirection userTriggerredSwipeToDeleteDirection = [self deletionDirectionWithVelocity:velocity andTargetOffset:*targetContentOffset];
    BOOL shouldDelete = (userTriggerredSwipeToDeleteDirection != LSSwipeToDeleteDirectionNone);
    
    if ([self.swipeToDeleteDelegate respondsToSelector:@selector(swipeToDeleteViewController:willEndDraggingCellAtIndexPath:willDeleteCell:)]) {
        [self.swipeToDeleteDelegate swipeToDeleteViewController:self willEndDraggingCellAtIndexPath:selectedIndexPath willDeleteCell:shouldDelete];
    }
    
    void (^completionBlock)(BOOL finished) = ^(BOOL finished){
        if (finished) {
            if ([self.swipeToDeleteDelegate respondsToSelector:@selector(swipeToDeleteViewController:didEndAnimationWithCellAtIndexPath:didDeleteCell:)]) {
                [self.swipeToDeleteDelegate swipeToDeleteViewController:self didEndAnimationWithCellAtIndexPath:selectedIndexPath didDeleteCell:shouldDelete];
            }
        }
    };
    
    *targetContentOffset = scrollView.contentOffset;
    
    if (shouldDelete) {
        [self performSwipeToDeleteForCellsAtIndexPaths:@[selectedIndexPath] withCompletion:completionBlock];
    }else{
        [self cancelSwipeToDeleteForCellsAtIndexPaths:@[selectedIndexPath] withCompletion:completionBlock];
    }
}

-(void)scrollViewCell:(LSScrollViewCell *)cell scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    cell.insectType = [self insectTypeForScrollViewCell:cell atIndexPath:indexPath];
    [cell adjustScrollViewInsectsInSuperView:scrollView];
}

-(void)performSwipeToDeleteForCellsAtIndexPaths:(NSArray *)indexPathsToDelete withCompletion:(void (^)(BOOL finished))completionBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 delay:0.0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            [indexPathsToDelete enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                LSScrollViewCell *cell = (LSScrollViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell scrollToEdge];
                
            }];
        } completion:^(BOOL finished) {
            [indexPathsToDelete enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSAssert(self.swipeToDeleteDelegate, @"No delegate found");
                [self.swipeToDeleteDelegate swipeToDeleteViewController:self didDeleteCellAtIndexPath:indexPath];
            }];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:indexPathsToDelete];
            }  completion:^(BOOL finished) {
                if (completionBlock) completionBlock(finished);
            }];
        }];
    });
}

-(void)cancelSwipeToDeleteForCellsAtIndexPaths:(NSArray *)indexPaths withCompletion:(void (^)(BOOL finished))completionBlock{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        LSScrollViewCell *cell = (LSScrollViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell resetScrollViewAnimated:YES];
    }];
}

-(LSSwipeToDeleteDirection)deletionDirectionWithVelocity:(CGPoint)velocity andTargetOffset:(CGPoint)targetOffset{
    LSSwipeToDeleteDirection direction = LSSwipeToDeleteDirectionNone;
    
    CGPoint tranlastion = CGPointZero;
    tranlastion.x -= targetOffset.x;
    tranlastion.y -= targetOffset.y;
    CGFloat escapeDistance = [self translationValueFromTranlation:tranlastion];
    CGFloat escapeVelocity = [self velocityMagnitudeFromVelocity:velocity];
    
    if (escapeDistance > self.deletionDistanceTresholdValue && [self isTranslationInDeletionDirection:tranlastion]) {
        direction = [self swipeToDeleteDirectionFromValue:tranlastion];
    }else if (escapeVelocity > self.deletionVelocityTresholdValue && [self isVelocityInDeletionDirection:velocity]){
        direction = [self swipeToDeleteDirectionFromValue:tranlastion];
    }
    
    return direction;
}

-(CGFloat)translationValueFromTranlation:(CGPoint)tranlation{
    CGFloat tranlationValue = 0.0f;
    
    if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        tranlationValue = tranlation.x;
    }else if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        tranlationValue = tranlation.y;
    }
    
    return fabsf(tranlationValue);
}

-(CGFloat)velocityMagnitudeFromVelocity:(CGPoint)velocity{
    CGFloat velocityValue = 0.0f;
    
    if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        velocityValue = velocity.x;
    }else if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        velocityValue = velocity.y;
    }
    
    return fabsf(velocityValue);
}

-(LSSwipeToDeleteDirection)swipeToDeleteDirectionFromValue:(CGPoint)value{
    
    LSSwipeToDeleteDirection direction = LSSwipeToDeleteDirectionNone;
    
    if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (value.x < 0) {
            direction = LSSwipeToDeleteDirectionMin;
        }else if (value.x > 0){
            direction = LSSwipeToDeleteDirectionMax;
        }
    }else if (self.swipeToDeleteCollectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        if (value.y < 0) {
            direction = LSSwipeToDeleteDirectionMin;
        }else if (value.y > 0){
            direction = LSSwipeToDeleteDirectionMax;
        }
    }
    
    return direction;
}

-(BOOL)isVelocityInDeletionDirection:(CGPoint)velocity{
    
    LSSwipeToDeleteDirection userTriggerredSwipeToDeleteVelocityDirection = [self swipeToDeleteDirectionFromValue:velocity];
    BOOL inDeletionDirection = (self.swipeToDeleteDirection & userTriggerredSwipeToDeleteVelocityDirection);
    
    if (userTriggerredSwipeToDeleteVelocityDirection == LSSwipeToDeleteDirectionNone) {
        inDeletionDirection = NO;
    }
    
    return inDeletionDirection;
}

-(BOOL)isTranslationInDeletionDirection:(CGPoint)translation{
    
    LSSwipeToDeleteDirection userTriggerredSwipeToDeleteTranslationDirection = [self swipeToDeleteDirectionFromValue:translation];
    BOOL inDeletionDirection = (self.swipeToDeleteDirection & userTriggerredSwipeToDeleteTranslationDirection);
    
    if (userTriggerredSwipeToDeleteTranslationDirection == LSSwipeToDeleteDirectionNone) {
        inDeletionDirection = NO;
    }
    
    return inDeletionDirection;
}

-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller didDeleteCellAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
