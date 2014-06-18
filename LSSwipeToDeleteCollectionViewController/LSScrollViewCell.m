//
//  LSScrollViewCell.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import "LSScrollViewCell.h"

@interface LSScrollViewCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LSScrollViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpScrollView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpScrollView];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self setUpScrollView];
    }
    return self;
}

- (void)setUpScrollView{
    [self setClipsToBounds:NO];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setAlwaysBounceVertical:YES];
    [scrollView setClipsToBounds:NO];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    UIView *contentView = [UIView new];
    self.scrollViewContentView = contentView;
    
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [scrollView addSubview:contentView];
    [self addSubview:scrollView];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:contentView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:scrollView attribute:(NSLayoutAttributeCenterX) multiplier:1.0f constant:0.0f];
    [scrollView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:contentView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:scrollView attribute:(NSLayoutAttributeCenterY) multiplier:1.0f constant:0.0f];
    [scrollView addConstraint:constraint];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(scrollView, contentView);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:viewsDictionary];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:(NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY) metrics:nil views:viewsDictionary];
    [scrollView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:viewsDictionary];
    [scrollView addConstraints:constraints];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self resetScrollViewAnimated:NO];
}

- (void)resetScrollViewAnimated:(BOOL)animate{
    [self.scrollView setContentOffset:CGPointZero animated:animate];
}


-(void)scrollToEdgeInDirection:(LSSwipeToDeleteDirection)direction{
    CGPoint point = [self edgePointInDirection:direction];
    [self.scrollView setContentOffset:point animated:NO];
}

-(CGPoint)edgePointInDirection:(LSSwipeToDeleteDirection)direction{
    CGPoint point = self.scrollView.bounds.origin;
    if (self.insectType & LSScrollViewInsectTypeTop && direction == LSSwipeToDeleteDirectionMax) {
        point.y = -self.scrollView.contentInset.top;
    }
    if (self.insectType & LSScrollViewInsectTypeLeft && direction == LSSwipeToDeleteDirectionMax) {
        point.x = -self.scrollView.contentInset.left;
    }
    if (self.insectType & LSScrollViewInsectTypeBottom && direction == LSSwipeToDeleteDirectionMin) {
        point.y = self.scrollView.contentInset.bottom;
    }
    if (self.insectType & LSScrollViewInsectTypeRight && direction == LSSwipeToDeleteDirectionMin) {
        point.x = self.scrollView.contentInset.right;
    }
    return point;
}

-(void)adjustScrollViewInsectsInSuperView:(UIView *)superview{
    [self.scrollView layoutIfNeeded];
    CGFloat top = 0.0f;
    CGFloat left = 0.0f;
    CGFloat bottom = 0.0f;
    CGFloat right = 0.0f;
    
    if (self.insectType & LSScrollViewInsectTypeTop) {
        top = CGRectGetMaxY(superview.bounds) - CGRectGetMinY(self.bounds);
    }
    if (self.insectType & LSScrollViewInsectTypeLeft) {
        left = CGRectGetMaxX(superview.bounds) - CGRectGetMinX(self.bounds);
    }
    if (self.insectType & LSScrollViewInsectTypeBottom) {
        bottom = CGRectGetMaxY(self.frame);
    }
    if (self.insectType & LSScrollViewInsectTypeRight) {
        right = CGRectGetMaxX(self.frame);
    }
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(top, left, bottom, right)];
    [self.scrollView setContentOffset:CGPointZero];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self.scrollViewDelegate scrollViewCell:self scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.scrollViewDelegate scrollViewCell:self scrollViewWillBeginDragging:scrollView];
}

@end
