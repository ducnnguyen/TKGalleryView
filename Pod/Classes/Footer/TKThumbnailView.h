//
//  TKThumbnailView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TKGalleryViewDatasource;
@class TKGalleryViewController;
@interface TKThumbnailView : UIView

@property (nonatomic, weak) id<TKGalleryViewDatasource> datasource;
@property (nonatomic, weak) TKGalleryViewController *gallery;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UIColor *footerBackground;
@property (nonatomic, copy) void (^thumbnailDidChange)(TKThumbnailView *view,NSInteger index);

- (void)setListThumbnail:(NSArray *)listThumbnail atIndex:(NSInteger)index;

@end
