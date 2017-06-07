//
//  TKDemoViewController.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TKBPhotoReviewDetailViewContrllerDelegate;
@interface TKBPhotoReviewDetailViewContrller : UIViewController
@property (nonatomic,weak) id <TKBPhotoReviewDetailViewContrllerDelegate> delegate;
@property (nonatomic,strong) UIImage *scaleImage;
@property (nonatomic,strong) UIColor *reviewBackground;
@property (nonatomic) UIViewContentMode contentMode;
- (id)initWithAnimationFromView:(UIView *)view;
- (id)initWithAnimationFromView:(UIView *)view showCaption:(BOOL)isShowCaption;
- (void)setDataSource:(id)listDataSouce;
- (void)setDataSource:(id)listDataSouce atIndex:(NSInteger)index;


@property (nonatomic) NSInteger currentIndex;
@end
@class PhotoReview;
@protocol TKBPhotoReviewDetailViewContrllerDelegate <NSObject>
- (void)photo:(TKBPhotoReviewDetailViewContrller *)photo didClickThanksAtIndex:(NSInteger)index;

@end
