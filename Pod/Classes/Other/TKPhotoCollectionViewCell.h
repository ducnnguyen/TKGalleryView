//
//  TKCollectionViewCell.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKReviewModalProtocol.h"
@interface TKPhotoCollectionViewCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setPhoto:(id<TKReviewModalProtocol>)photo;
- (CGPoint)imageviewCurrentOrigin;
- (CGFloat)currentScale;
- (CGFloat)minScale;
- (CGFloat)maxScale;


@end
