//
//  TKDemoViewController.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TKGalleryViewDelegate;
@protocol TKGalleryViewDatasource;

@interface TKGalleryViewController : UIViewController
@property (nonatomic,weak) id <TKGalleryViewDatasource> datasource;
@property (nonatomic,weak) id <TKGalleryViewDelegate> delegate;
@property (nonatomic,strong) UIImage *scaleImage;
@property (nonatomic,strong) UIColor *reviewBackground;
@property (nonatomic) UIViewContentMode contentMode;

- (id)initWithAnimationFromView:(UIView *)view;
- (id)initWithAnimationFromView:(UIView *)view showCaption:(BOOL)isShowCaption;
- (void)setDataSource:(id)listDataSouce;
- (void)setDataSource:(id)listDataSouce atIndex:(NSInteger)index;

@property (nonatomic) NSInteger currentIndex;

@end


@protocol TKGalleryViewDatasource <NSObject>
@required
- (NSInteger)numberOfPhotos:(TKGalleryViewController*)gallery;
- (NSString*)gallery:(TKGalleryViewController*)gallery imageAtIndex:(NSInteger)index;
@optional
- (NSString*)gallery:(TKGalleryViewController*)gallery captionAtIndex:(NSInteger)index;
- (CGFloat)gallery:(TKGalleryViewController*)gallery ratingAtIndex:(NSInteger)index;

@end

@protocol TKGalleryViewDelegate <NSObject>
- (void)photo:(TKGalleryViewController *)photo didClickThanksAtIndex:(NSInteger)index;


@end
