//
//  TKGalleryDelegateAndDatasource.h
//  Pods
//
//  Created by Duc Nguyen on 6/9/17.
//
//

@class TKGalleryViewController;
@protocol TKReviewModalProtocol;
@protocol TKCaptionProtocol;

@protocol TKGalleryViewDatasource <NSObject>

@required
- (NSInteger)numberOfPhotos:(TKGalleryViewController*)gallery;
- (id<TKReviewModalProtocol, TKCaptionProtocol>)gallery:(TKGalleryViewController*)gallery itemAtIndex:(NSInteger)index;

@optional
- (NSString*)gallery:(TKGalleryViewController*)gallery captionAtIndex:(NSInteger)index;
- (CGFloat)gallery:(TKGalleryViewController*)gallery ratingAtIndex:(NSInteger)index;

@end

@protocol TKGalleryViewDelegate <NSObject>

- (void)photo:(TKGalleryViewController *)photo didClickThanksAtIndex:(NSInteger)index;
- (void)photo:(TKGalleryViewController *)photo didClickReplyAtIndex:(NSInteger)index;

@end
