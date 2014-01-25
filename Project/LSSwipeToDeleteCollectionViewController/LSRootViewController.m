//
//  LSViewController.m
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
