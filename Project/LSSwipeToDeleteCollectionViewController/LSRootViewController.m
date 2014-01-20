//
//  LSViewController.m
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSBottomCollectionViewController.h"
#import "LSTopCollectionViewController.h"

@interface LSRootViewController ()
@property (nonatomic, strong) LSBottomCollectionViewController *bottomCollectionViewController;
@property (nonatomic, strong) LSTopCollectionViewController *topCollectionViewController;
@end

@implementation LSRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCollectionViews];
}

- (void)setUpCollectionViews{
    
    id topLayoutGuide = self.topLayoutGuide;
    
    LSBottomCollectionViewController *bottomCollectionViewController = [[LSBottomCollectionViewController alloc] initWithCollectionViewLayout:[LSBottomCollectionViewController defaultCollectionViewLayout]];
    
    UIView *bottomCollectionView = bottomCollectionViewController.view;
    [self.view addSubview:bottomCollectionView];
    [bottomCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [bottomCollectionViewController willMoveToParentViewController:self];
    [self addChildViewController:bottomCollectionViewController];
    [bottomCollectionViewController didMoveToParentViewController:self];
    
    self.bottomCollectionViewController = bottomCollectionViewController;
    
    
    LSTopCollectionViewController *topCollectionViewController = [[LSTopCollectionViewController alloc] initWithCollectionViewLayout:[LSTopCollectionViewController defaultCollectionViewLayout]];
    
    UIView *topCollectionView = topCollectionViewController.view;
    [self.view addSubview:topCollectionView];
    [topCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [topCollectionViewController willMoveToParentViewController:self];
    [self addChildViewController:topCollectionViewController];
    [topCollectionViewController didMoveToParentViewController:self];
    
    self.topCollectionViewController = topCollectionViewController;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(bottomCollectionView, topCollectionView, topLayoutGuide);
    
    NSArray *constraints = [ NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomCollectionView]|" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    constraints = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topCollectionView][bottomCollectionView(100)]|" options:(NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight) metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
