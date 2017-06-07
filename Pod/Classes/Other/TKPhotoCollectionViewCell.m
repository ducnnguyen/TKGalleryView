//
//  TKCollectionViewCell.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKPhotoCollectionViewCell.h"
#import "TKZommingScrollView.h"
@interface TKPhotoCollectionViewCell()
@property (nonatomic,strong) TKZommingScrollView *zommingScrollView;
@end

@implementation TKPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        _zommingScrollView = [[TKZommingScrollView alloc] initWithPhotoReviewsController:nil];
        _zommingScrollView.backgroundColor = [UIColor clearColor];
        _zommingScrollView.opaque = YES;
        _zommingScrollView.frame = [[UIScreen mainScreen] bounds];
        [self.contentView addSubview:_zommingScrollView];
    }
    return self;
}
- (void)setPhoto:(id<TKReviewModalProtocol>)photo {
    [self.zommingScrollView setPhoto:photo];
}

- (CGPoint)imageviewCurrentOrigin {
    return self.zommingScrollView.photoImageView.frame.origin;
}
- (CGFloat)currentScale {
   return  [self.zommingScrollView zoomScale];
}
- (CGFloat)minScale {
    return  [self.zommingScrollView minimumZoomScale];

}
- (CGFloat)maxScale {
    return  [self.zommingScrollView maximumZoomScale];

}
@end
