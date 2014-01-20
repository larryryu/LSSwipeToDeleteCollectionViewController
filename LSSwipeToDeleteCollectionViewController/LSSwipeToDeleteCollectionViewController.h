//
//  LSTopCollectionViewController.h
//  SwipeToDelete
//
//  Created by Lukman Sanusi on 1/14/14.
//  Copyright (c) 2014 Lukman Sanusi. All rights reserved.
//

#import "LSScrollViewCell.h"

static const CGFloat LSSwipeToDeleteCollectionViewControllerDefaultDeletionDistanceTresholdValue = 100.0f;
static const CGFloat LSSwipeToDeleteCollectionViewControllerDefaultDeletionVelocityTresholdValue = 1.0f;

typedef NS_ENUM(NSInteger, LSSwipeToDeleteDirection){
    LSSwipeToDeleteDirectionNone    =   1 << 0,      // prevents deletion
    LSSwipeToDeleteDirectionMin     =   1 << 1, // Causes deletion animation toward the CollectionView's bounds minX or minY
    LSSwipeToDeleteDirectionMax     =   1 << 2  // Causes deletion animation toward the CollectionView's bounds maxX or maxY
};

@protocol LSSwipeToDeleteCollectionViewControllerDelegate;

@interface LSSwipeToDeleteCollectionViewController : UICollectionViewController <LSSwipeToDeleteCollectionViewControllerDelegate>
@property (nonatomic, assign) LSSwipeToDeleteDirection swipeToDeleteDirection;
@property (nonatomic, assign) id <LSSwipeToDeleteCollectionViewControllerDelegate> swipeToDeleteDelegate;
@property (nonatomic, assign) CGFloat deletionDistanceTresholdValue;
@property (nonatomic, assign) CGFloat deletionVelocityTresholdValue;
@end


@protocol LSSwipeToDeleteCollectionViewControllerDelegate <NSObject>
/* required method. The datasoures need to remove the object at the specified indexPath */
-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller didDeleteCellAtIndexPath:(NSIndexPath *)indexPath;

@optional
/* return YES to allow the for deletion of the indexPath. Default is YES */
-(BOOL)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller canDeleteCellAtIndexPath:(NSIndexPath *)indexPath;
/* Called just after the pan to delete gesture is recognised with a proposed item for deletion. */
-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath;
/* Called just after the user lift the finger and right before the deletion/restoration animation begins. */
-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller willEndDraggingCellAtIndexPath:(NSIndexPath *)indexPath willDeleteCell:(BOOL)willDelete;
/* Called just after the deletion/restoration animation ended. */
-(void)swipeToDeleteViewController:(LSSwipeToDeleteCollectionViewController *)controller didEndAnimationWithCellAtIndexPath:(NSIndexPath *)indexPath didDeleteCell:(BOOL)didDelete;
@end