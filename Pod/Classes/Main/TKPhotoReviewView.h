//
//  TKPhotoReviewView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKPhotoCollectionViewCell.h"
#import "TKPhotoProtocol.h"
@class PhotoReview;
@interface TKPhotoReviewView : UIView
@property (nonatomic,strong) NSArray<PhotoReview> *reviews;
@property (nonatomic,copy) void(^photoReviewDidChange)(TKPhotoReviewView *,NSInteger index);
@property (nonatomic,copy)void(^didShowFullCaption)(UITextView* content);

@property (nonatomic,copy) void (^didClickThanks)(NSInteger index, PhotoReview*);
@property (nonatomic,copy) void (^didReply)(NSInteger index, PhotoReview*);
@property (nonatomic,copy) void (^didClose)();

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL isHiddenCaption;
@property (nonatomic,strong) UIColor *contentBackground;
@property (nonatomic,strong) UIColor *btnTintColor;

- (void)setReviews:(NSArray<PhotoReview*>*)reviews withStartAtIndex:(NSInteger)index isShowCaption:(BOOL)isShowCaption;
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated;
- (TKPhotoCollectionViewCell *)viewIsVisible;
@end
