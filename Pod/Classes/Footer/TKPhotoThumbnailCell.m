//
//  TKPhotoThumbnailCell.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKPhotoThumbnailCell.h"
#import "UIImageView+WebCache.h"
#import "TKReviewModalProtocol.h"
#import "UIImageView+WebCache.h"
@interface TKPhotoThumbnailCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@end
@implementation TKPhotoThumbnailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setPhoto:(id<TKReviewModalProtocol>)photoReview {
    
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:[photoReview tk_fullPathImage]] placeholderImage:kAppPlaceHolderImage];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setselectedView:selected];
}

- (void)setselectedView:(BOOL)isSelected {
    if (isSelected) {
        self.opactityView.alpha = 0;
        [self.thumbImageView.layer setBorderColor:[UIColor colorWithRed:251/255.f green:130/255.f blue:39/255.f alpha:1].CGColor];
        [self.thumbImageView.layer setBorderWidth:1];
    }
    else {
        self.opactityView.alpha = 1;
        [self.thumbImageView.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.thumbImageView.layer setBorderWidth:0];

    }
}


@end
