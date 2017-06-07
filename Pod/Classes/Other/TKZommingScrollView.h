//
//  TKZommingScrollView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKReviewModalProtocol.h"
#import "TKTapDetectingPhotoView.h"
#import "TKTapDetectingView.h"
@interface TKZommingScrollView : UIScrollView <UIScrollViewDelegate,TKTapDetectingImageViewDelegate,TKTapDetectingViewDelegate>
@property (nonatomic,strong) id <TKReviewModalProtocol> photo;
@property (nonatomic,weak) id reviewController;
@property (nonatomic) CGFloat maximumDoubleTapZoomScale;
@property (nonatomic,strong) TKTapDetectingPhotoView *photoImageView;

//
- (instancetype)initWithPhotoReviewsController:(id )reviewController;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

@end
