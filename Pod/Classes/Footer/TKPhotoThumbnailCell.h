//
//  TKPhotoThumbnailCell.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TKReviewModalProtocol;
@interface TKPhotoThumbnailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *opactityView;
- (void)setPhoto:(id<TKReviewModalProtocol>)photoReview;
- (void)setselectedView:(BOOL)isSelected;
@end
