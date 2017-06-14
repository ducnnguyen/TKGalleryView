//
//  TKPhotoReviewView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKPhotoCollectionViewCell.h"
#import "TKGalleryViewController.h"

@interface TKPhotoReviewView : UIView

@property (nonatomic, weak) id <TKGalleryViewDatasource> datasource;
@property (nonatomic, weak) id <TKGalleryViewDelegate> delegate;

@property (nonatomic, copy) void(^photoReviewDidChange)(TKPhotoReviewView *,NSInteger index);
@property (nonatomic, copy) void(^didShowFullCaption)(UITextView* content);

@property (nonatomic, copy) void (^didClose)();
@property (nonatomic, copy) void (^didClickThanks)();
@property (nonatomic, copy) void (^didReply)();

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL isHiddenCaption;
@property (nonatomic, strong) UIColor *contentBackground;
@property (nonatomic, strong) UIColor *btnTintColor;
@property (nonatomic, weak) TKGalleryViewController *gallery;


- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated;
- (TKPhotoCollectionViewCell *)viewIsVisible;

@end
