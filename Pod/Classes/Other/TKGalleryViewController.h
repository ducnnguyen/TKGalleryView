//
//  TKDemoViewController.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKReviewModalProtocol.h"
#import "TKGalleryDelegateAndDatasource.h"

@interface TKGalleryViewController : UIViewController

@property (nonatomic, weak) id <TKGalleryViewDatasource> datasource;
@property (nonatomic, weak) id <TKGalleryViewDelegate> delegate;
@property (nonatomic,strong) UIImage *scaleImage;
@property (nonatomic,strong) UIColor *reviewBackground;
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic, assign) BOOL isShowCaption;

- (instancetype)initWithAnimationFromView:(UIView *)view;
- (instancetype)initWithAnimationFromView:(UIView *)view showCaption:(BOOL)isShowCaption;



@property (nonatomic) NSInteger currentIndex;

@end


