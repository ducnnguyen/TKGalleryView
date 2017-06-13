//
//  TKDemoViewController.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKGalleryViewController.h"
#import "TKPhotoReviewView.h"
#import "TKThumbnailView.h"
#import "TKPhotoCollectionViewCell.h"
#import "pop/POP.h"
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "UIView+PodBundle.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TKGalleryViewController () {
    UIWindow *_applicationWindow;
    UIViewController *_applicationTopViewController;
    int _previousModalPresentationStyle;
    BOOL _isdraggingPhoto;
    BOOL _isShowCaption;
}

@property (strong, nonatomic) TKPhotoReviewView *contentView;
@property (strong, nonatomic) TKThumbnailView *footerView;
@property (nonatomic, strong)     UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIView *parentView;
@property (nonatomic, strong) id dataSourceLive;
@property (nonatomic) NSInteger indexLib;
@property (nonatomic, strong) NSArray *arr ;
@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic) CGRect rectFromPresent;

@end

@implementation TKGalleryViewController
@synthesize reviewBackground  = _reviewBackground;

- (id)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (id)initWithAnimationFromView:(UIView *)view {
    return [self initWithAnimationFromView:view showCaption:YES];
}

- (id)initWithAnimationFromView:(UIView *)view showCaption:(BOOL)isShowCaption {
    if (self = [self init]) {
        _animatedView = view;
        _isShowCaption = isShowCaption;
        _contentMode = UIViewContentModeScaleAspectFill;
        self.parentView =  [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.parentView];
        [self.parentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        self.footerView = [TKThumbnailView viewFromPodNib];
        
        [self.parentView addSubview:self.footerView];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(72);
        }];
        
        self.contentView = [TKPhotoReviewView viewFromPodNib];
        [self.parentView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.equalTo(self.footerView.mas_top).with.offset(0);
        }];
        
        self.contentView.gallery = self;
    }
    return self;
}

#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha  = 1;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.view.backgroundColor = [UIColor blackColor];
    _applicationWindow.backgroundColor = [UIColor greenColor];
    if (self.scaleImage && self.currentIndex == self.indexLib) {
        [self performPresentAnimation];
    }
    @weakify(self);
    [self.contentView setPhotoReviewDidChange:^(TKPhotoReviewView *view, NSInteger index) {
        @strongify(self);
        self.footerView.currentIndex = index;
        self.currentIndex = index;
    }];
    
    
    [self.footerView setThumbnailDidChange:^(TKThumbnailView *view, NSInteger index) {
        @strongify(self);
        self.contentView.currentIndex = index;
        self.currentIndex = index;
    }];
    
    
    [self.contentView setDidClose:^{
        @strongify(self);
        if (self.scaleImage && self.currentIndex == self.indexLib ) {
            [self performCloseAnimationWithScrollView:self.contentView.viewIsVisible];
        }
        else {
            self.animatedView.hidden = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }];
    
    /*
    [self.contentView setDidClickThanks:^(NSInteger index, PhotoReview *photoReview) {
    }];
    [self.contentView setDidReply:^(NSInteger index, PhotoReview *photoReview) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(photo:didClickThanksAtIndex:)]) {
            [self.delegate photo:self didClickThanksAtIndex:index];
        }
    }];
    
    _applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_panGesture setMinimumNumberOfTouches:1];
    [_panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:_panGesture];
    if (self.dataSourceLive) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.contentView setReviews:self.dataSourceLive withStartAtIndex:self.indexLib isShowCaption:_isShowCaption];
            [self.footerView setListThumbnail:self.dataSourceLive atIndex:self.indexLib];

        });
    }
    */
    
    self.footerView.footerBackground = self.reviewBackground;
    self.contentView.contentBackground = self.reviewBackground;
    self.view.backgroundColor =self.reviewBackground;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSigTap) name:@"TKPhotoSignTap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDoubleTap) name:@"TKPhotoDoubleTap" object:nil];
    
    bool isClearColor = CGColorEqualToColor(self.reviewBackground.CGColor, [UIColor whiteColor].CGColor);
    if (isClearColor) {
        self.contentView.btnTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setReviewBackground:(UIColor *)reviewBackground {
    _reviewBackground = reviewBackground;
}

- (UIColor *)reviewBackground {
    return _reviewBackground ? _reviewBackground : [UIColor blackColor];
}



- (void)performPresentAnimation {
    self.view.alpha = 1;
    UIImage *imageFromView = self.scaleImage ? self.scaleImage : [self getImageFromView:self.animatedView];
    CGRect rect = [self.animatedView.superview convertRect:self.animatedView.frame toView:nil];
    _rectFromPresent = rect;
    UIView *fadeView = [[UIView alloc] initWithFrame:_applicationWindow.bounds];
    fadeView.backgroundColor = self.reviewBackground;
    fadeView.alpha = 0;
    [_applicationWindow addSubview:fadeView];
    
    UIImageView *resizeableImageView = [[UIImageView alloc] initWithImage:imageFromView];
    resizeableImageView.frame = rect;
    resizeableImageView.clipsToBounds = YES;
    resizeableImageView.backgroundColor = [UIColor clearColor];
    [resizeableImageView setContentMode:(self.contentMode)];
    [_applicationWindow addSubview:resizeableImageView];
    self.animatedView.hidden =  YES;
    
    void (^completion)() = ^() {
        self.view.alpha = 1.0f;
        resizeableImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        [fadeView removeFromSuperview];
        [resizeableImageView removeFromSuperview];
    };
    CGRect finalImageViewFrame = [self animationFrameForImage:imageFromView presenting:YES scrollView:nil];

    
    [UIView animateWithDuration:0.2 animations:^{
        fadeView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
    }];
    
    [self animateView:resizeableImageView toFrame:finalImageViewFrame completion:completion];
    
}

- (void)performCloseAnimationWithScrollView:(TKPhotoCollectionViewCell *)scrollView {
    
    float fadeAlpha = 1 - fabs(scrollView.frame.origin.y)/scrollView.frame.size.height;
    
    UIImage *imageFromView = self.scaleImage;
    
    UIView *fadeView = [[UIView alloc] initWithFrame:_applicationWindow.bounds];
    fadeView.backgroundColor = [UIColor clearColor];
    fadeView.alpha = fadeAlpha;
    [_applicationWindow addSubview:fadeView];
    
    CGRect imageViewFrame = [self animationFrameForImage:imageFromView presenting:NO scrollView:scrollView];
    UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:imageFromView];
    resizableImageView.frame = imageViewFrame;
    [resizableImageView setContentMode:(self.contentMode)];
    resizableImageView.backgroundColor = [UIColor clearColor];
    resizableImageView.clipsToBounds = YES;
    [_applicationWindow addSubview:resizableImageView];
    self.view.hidden = YES;

    void (^completion)() = ^() {
        _animatedView.hidden = NO;
        _animatedView = nil;
        _scaleImage = nil;
        
        [fadeView removeFromSuperview];
        [resizableImageView removeFromSuperview];
        
        [self prepareForClosePhotoBrowser];
        [self dismissPhotoBrowserAnimated:NO];
    };
    
    [UIView animateWithDuration:0.28 animations:^{
        fadeView.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:nil];
    
    CGRect senderViewOriginalFrame = _animatedView.superview ? [_animatedView.superview convertRect:_animatedView.frame toView:nil] : _rectFromPresent;
    [self animateView:resizableImageView
              toFrame:senderViewOriginalFrame
           completion:completion];
}

- (void)dismissPhotoBrowserAnimated:(BOOL)animated {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
      [self dismissViewControllerAnimated:animated completion:^{
    }];
}

- (void)prepareForClosePhotoBrowser {
    // Gesture
    [_applicationWindow removeGestureRecognizer:_panGesture];
        // Controls
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
}

- (CGRect)animationFrameForImage:(UIImage *)image presenting:(BOOL)presenting scrollView:(TKPhotoCollectionViewCell *)scrollView {
    if (!image) {
        return CGRectZero;
    }
    
    CGSize imageSize = image.size;
    
    CGFloat maxWidth = CGRectGetWidth(_applicationWindow.bounds);
    CGFloat maxHeight = CGRectGetHeight(_applicationWindow.bounds);
    
    CGRect animationFrame = CGRectZero;
    
    CGFloat aspect = imageSize.width / imageSize.height;
    if (maxWidth / aspect <= maxHeight) {
        animationFrame.size = CGSizeMake(maxWidth, maxWidth / aspect);
    }
    else {
        animationFrame.size = CGSizeMake(maxHeight * aspect, maxHeight);
    }
    
    animationFrame.origin.x = roundf((maxWidth - animationFrame.size.width) / 2.0f);
    animationFrame.origin.y = roundf((maxHeight - animationFrame.size.height) / 2.0f);
    
    if (!presenting) {
        animationFrame.origin.y = [self parentView].frame.origin.y;
        animationFrame.origin.y +=  scrollView.imageviewCurrentOrigin.y ;
    }
    
    return animationFrame;
}

- (void)setDelegate:(id<TKGalleryViewDelegate>)delegate {
    self.contentView.delegate = delegate;
}
- (void)setDatasource:(id<TKGalleryViewDatasource>)datasource {
    self.contentView.datasource = datasource;
}
#pragma mark - pop Animation

- (void)animateView:(UIView *)view toFrame:(CGRect)frame completion:(void (^)(void))completion {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    [animation setSpringBounciness:6];
    [animation setDynamicsMass:1];

    [animation setToValue:[NSValue valueWithCGRect:frame]];
    [view pop_addAnimation:animation forKey:nil];
    
    if (completion) {
        [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            completion();
        }];
    }
}


- (void)didSigTap {
    TKPhotoCollectionViewCell *cell = [self.contentView viewIsVisible];
    CGFloat currentScale = cell.currentScale;
    if (currentScale  < [cell maxScale]) {
        [self setControlsHiddenNotHiddenThumb:self.contentView.isHiddenCaption animated:YES];
    }
    else {
        [self setControlsHiddenNotHiddenThumb:NO animated:YES];
        
    }
}

- (void)didDoubleTap {
    TKPhotoCollectionViewCell *cell = [self.contentView viewIsVisible];
    CGFloat currentScale = cell.currentScale;
    if (currentScale  < [cell maxScale]) {
        [self setControlsHiddenNotHiddenThumb:YES animated:YES];
    }
    else {
        [self setControlsHiddenNotHiddenThumb:NO animated:YES];

    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setDataSource:(id)listDataSouce {
    [self setDataSource:listDataSouce atIndex:0];
}

- (void)setDataSource:(id)listDataSouce atIndex:(NSInteger)index {
    self.dataSourceLive  = listDataSouce;
    self.indexLib = self.currentIndex  = index;
}


- (UIViewController *)topviewController
{
    UIViewController *topviewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topviewController.presentedViewController) {
        topviewController = topviewController.presentedViewController;
    }
    
    return topviewController;
}
#pragma mark - Pan Gesture
- (UIImage *)getImageFromView :(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 2);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}
- (void)panGestureRecognized:(UIPanGestureRecognizer *)gesture {
    UIView *tranlasteView = [self parentView];
    
    static float firstX, firstY;
    
    float viewHeight = tranlasteView.frame.size.height;
    float viewHalfHeight = viewHeight/2;

    
    CGPoint translatedPoint = [gesture translationInView:tranlasteView];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        firstX = [tranlasteView center].x;
        firstY = [tranlasteView center].y;
        self.animatedView.hidden = (self.currentIndex == self.indexLib);

        [self setControlsHidden:YES animated:YES];
        _isdraggingPhoto = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    translatedPoint = CGPointMake(firstX, firstY + translatedPoint.y);
    [tranlasteView setCenter:translatedPoint];
    
    float newY = tranlasteView.center.y - viewHalfHeight;
    float newAlpha =  1 - fabsf(newY) / viewHeight;
    self.view.opaque = YES;
    self.view.backgroundColor = [self.reviewBackground colorWithAlphaComponent:newAlpha]; //[UIColor colorWithWhite:0 alpha:newAlpha];
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        if (tranlasteView.center.y  > viewHalfHeight + 40 || tranlasteView.center.y < viewHalfHeight - 40) {
            //
            if (self.scaleImage && self.currentIndex == self.indexLib ) {
                [self performCloseAnimationWithScrollView:self.contentView.viewIsVisible];
                return;
            }

            CGFloat finalX = firstX, finalY;
            
            CGFloat windowsHeigt = [_applicationWindow frame].size.height;
            
            if(tranlasteView.center.y > viewHalfHeight+30) {
                finalY = windowsHeigt*2;

            }// swipe down
            else {// swipe up
                finalY = -viewHalfHeight;
            }
            CGFloat animationDuration = 0.35;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [tranlasteView setCenter:CGPointMake(finalX, finalY)];
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [UIView commitAnimations];
            [self performSelector:@selector(dissmissPhotoController) withObject:nil afterDelay:animationDuration];
            
        }
        else // Continue Showing View
        {
            _isdraggingPhoto = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            
            self.view.backgroundColor = [self.reviewBackground colorWithAlphaComponent:1]; //[UIColor colorWithWhite:0 alpha:newAlpha];

            CGFloat velocityY = (.35*[(UIPanGestureRecognizer*)gesture velocityInView:self.view].y);
            
            CGFloat finalX = firstX;
            CGFloat finalY = viewHalfHeight;
            
            CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [tranlasteView setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
        }

    }

}
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated {
    [self.contentView setControlsHidden:hidden animated:animated];
    [UIView animateWithDuration:0.33 animations:^{
        CGFloat alpha = hidden ? 0 : 1;
        [self.footerView setAlpha:alpha];
    } completion:nil];
}

- (void)setControlsHiddenNotHiddenThumb:(BOOL)hidden animated:(BOOL)animated {
    [self.contentView setControlsHidden:hidden animated:animated];
    if (self.footerView.alpha == 0) {
        [UIView animateWithDuration:0.33 animations:^{
            CGFloat alpha = 1;
            [self.footerView setAlpha:alpha];
        } completion:nil];
    }
   }
- (void)dissmissPhotoController {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
