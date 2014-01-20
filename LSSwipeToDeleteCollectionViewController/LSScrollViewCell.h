//
//  LSScrollViewCell.h
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, LSScrollViewInsectType){
    LSScrollViewInsectTypeNone      = 0,
    LSScrollViewInsectTypeTop       = 1 << 0,
    LSScrollViewInsectTypeLeft      = 1 << 1,
    LSScrollViewInsectTypeBottom    = 1 << 2,
    LSScrollViewInsectTypeRight     = 1 << 3
};

@protocol LSScrollViewCellDelegate;

@interface LSScrollViewCell : UICollectionViewCell
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, assign) LSScrollViewInsectType insectType;
@property (nonatomic, assign) id<LSScrollViewCellDelegate>scrollViewDelegate;
- (void)adjustScrollViewInsectsInSuperView:(UIView *)superview;
- (void)resetScrollViewAnimated:(BOOL)animate;
- (void)scrollToEdge;
- (CGPoint) edgePoint;
@end

@protocol LSScrollViewCellDelegate <NSObject>
- (void)scrollViewCell:(LSScrollViewCell *)cell scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewCell:(LSScrollViewCell *)cell scrollViewWillBeginDragging:(UIScrollView *)scrollView;
@end