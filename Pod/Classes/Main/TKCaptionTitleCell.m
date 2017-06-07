//
//  TKCaptionTitleCell.m
//  TikiProject
//
//  Created by ZickOne on 11/29/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import "TKCaptionTitleCell.h"
#import "HCSStarRatingView.h"
@interface TKCaptionTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *startView;
@end
@implementation TKCaptionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setStart:(NSInteger)start title:(NSString *)title {
    self.title.text = title;
    [self.startView setValue:start];
}
@end
