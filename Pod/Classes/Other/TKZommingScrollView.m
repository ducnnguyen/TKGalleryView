//
//  TKZommingScrollView.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKZommingScrollView.h"
#import "UIImageView+WebCache.h"
#import "ReactiveCocoa.h"

@interface TKZommingScrollView()
@property (nonatomic,strong) TKTapDetectingView *detectingView;
@end
@implementation TKZommingScrollView

- (instancetype)initWithPhotoReviewsController:(id)reviewController {
    if ((self = [super init])) {
        self.reviewController = reviewController;
        
        //Detecting View
        _detectingView = [[TKTapDetectingView alloc] initWithFrame:self.bounds];
        _detectingView.tapDelegate = self;
        _detectingView.backgroundColor = [UIColor clearColor];
        [self addSubview:_detectingView];

        //Image View
        _photoImageView = [[TKTapDetectingPhotoView alloc] initWithFrame:CGRectZero];
        _photoImageView.tapDelegate  = self;
        _photoImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_photoImageView];
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        
    }
    return self;
}

- (void)setPhoto:(id<TKReviewModalProtocol>)photo {
    _photoImageView.image = nil;
    if (_photo != photo) {
        _photo = photo;
    }
    [self displayImage];

}

- (void)prepareForReuse {
    self.photo = nil;
}
#pragma mark- Display
- (void)displayImage {
    if (_photo) {
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeZero;
        
        @weakify(self)
        NSString *strURL = [self.photo tk_fullPathImage];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"place_holder"] options:0 completed:^(UIImage *imageServer, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self)
            UIImage *image = imageServer; //[self.photo getImage];
            if (!image) {
                image = [UIImage imageNamed:@"place_holder"];
            }
                self.photoImageView.image = image;
                self.photoImageView.hidden = NO;
                
                //Photo frame
                CGRect photoImageFrame;
                photoImageFrame.origin = CGPointZero;
                photoImageFrame.size = image.size;
                self.photoImageView.frame = photoImageFrame;
                self.contentSize = photoImageFrame.size;
                
                //Minimum
                [self setMaxMinZoomScalesForCurrentBounds];
                [self setNeedsDisplay];
        }];

    }
}
#pragma mark- Setup
- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail
    if (_photoImageView.image == nil) return;
    
    //Size
    CGSize boundSize = self.bounds.size;
    boundSize.width  -= 0.1;
    boundSize.height -= 0.1;
    
    CGSize imageSize = self.photoImageView.frame.size;
    
    //Caculate Min
    
    CGFloat xScale = boundSize.width / imageSize.width;
    CGFloat yScale = boundSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    //Caculate Max

    CGFloat maxScale = 4.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        if (maxScale < minScale) {
            maxScale = minScale * 2;
        }
    }
    
    // Calculate Max Scale Of Double Tap

    CGFloat maxDoubleTapZoomScale = 4.0 * minScale;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxDoubleTapZoomScale = maxDoubleTapZoomScale / [[UIScreen mainScreen] scale];
        if (maxDoubleTapZoomScale < minScale) {
            maxDoubleTapZoomScale = minScale * 2;
        }        
    }

    //Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    self.maximumDoubleTapZoomScale  = maxDoubleTapZoomScale;
    
    self.photoImageView.frame = CGRectMake(0, 0, self.photoImageView.frame.size.width, self.photoImageView.frame.size.height);
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.photoImageView.frame;
    
    self.detectingView.frame = self.bounds;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.photoImageView.frame, frameToCenter)) {
        self.photoImageView.frame = frameToCenter;
    }

}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark- Tap
- (void)handleDoubleTap:(CGPoint)touchPoint {
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (void)handleSignleTap:(CGPoint)touchPoint {
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

#pragma mark- Delegate
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKPhotoDoubleTap" object:self];
    [self handleDoubleTap:[touch locationInView:imageView]];
}

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSignleTap:[touch locationInView:imageView]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKPhotoSignTap" object:self];
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:view]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKPhotoDoubleTap" object:self];
}

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    [self handleSignleTap:[touch locationInView:view]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKPhotoSignTap" object:self];
}
@end
