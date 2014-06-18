//
//  LSSwipeToDeleteCollectionViewControllerKit.h
//  LSSwipeToDeleteCollectionViewControllerSample
//
//  Created by Lukman Sanusi on 6/17/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//


typedef NS_ENUM(NSInteger, LSSwipeToDeleteDirection){
    LSSwipeToDeleteDirectionNone    =   1 << 0,      // prevents deletion
    LSSwipeToDeleteDirectionMin     =   1 << 1, // Causes deletion animation toward the CollectionView's bounds minX or minY
    LSSwipeToDeleteDirectionMax     =   1 << 2  // Causes deletion animation toward the CollectionView's bounds maxX or maxY
};

#import "LSScrollViewCell.h"
#import "LSSwipeToDeleteCollectionViewController.h"

