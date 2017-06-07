//
//  TKCaptionDescriptionCell.m
//  TikiProject
//
//  Created by ZickOne on 11/29/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import "TKCaptionDescriptionCell.h"
#import "TTTAttributedLabel.h"
#import "UIColor+Tiki.h"

#define kNumberOfLines 2
#define space @"... "
#define ellipsis @"Xem thêm"

@interface TKCaptionDescriptionCell() {
    NSString *_textCaption;
    BOOL _isExpand;
}
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *captionLable;

@end
@implementation TKCaptionDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
    [self.captionLable addGestureRecognizer:tapper];
}
- (void)expand:(UITapGestureRecognizer *)tap {

    _isExpand = !_isExpand;
    float totalHeight  = 50;
    if (_isExpand) {
        self.captionLable.attributedText  = [[NSMutableAttributedString alloc] initWithString:_textCaption attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        totalHeight = [_textCaption boundingRectWithSize:CGSizeMake(self.captionLable.frame.size.width - 1 , CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.captionLable.font} context:nil].size.height;

    }


    if (self.didExpand) {
        self.didExpand(_isExpand,totalHeight);
    }
    

}

- (NSDictionary *)defaultAttributeText {
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineHeightMultiple:1.3f];

    return @{NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.6],
             NSFontAttributeName:[UIFont systemFontOfSize:14],
             NSParagraphStyleAttributeName:paragrahStyle};
}
- (void)setCaption:(NSString *)text shouldExpand:(BOOL)isExpand {
    _isExpand = isExpand ;
    _textCaption = text;
    if (_isExpand) {
        if (_textCaption) {
            self.captionLable.attributedText  = [[NSMutableAttributedString alloc] initWithString:_textCaption attributes:[self defaultAttributeText]];;
        }
    } else {
        if (text.length > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CATransition *animation = [CATransition animation];
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                animation.type = kCATransitionFade;
                animation.duration = 0.1;
                [self.captionLable.layer addAnimation:animation forKey:@"kCATransitionFade"];
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[self description:text maxLine:2] attributes:[self defaultAttributeText]];
                NSAttributedString *spaceAtrribute = [[NSAttributedString alloc] initWithString:space attributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
                
                
                NSAttributedString *seemore = [[NSAttributedString alloc] initWithString:ellipsis attributes:@{
                                                                                                               NSForegroundColorAttributeName :[UIColor tikiColor],
                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:14]}];
                [attributeStr appendAttributedString:spaceAtrribute];
                [attributeStr appendAttributedString:seemore];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.captionLable setAttributedText:attributeStr];
                });

            });
        }
    }
}

- (void)setCaption:(NSString *)text {
    [self setCaption:text shouldExpand:NO];
}

- (int)numberOfLinesNeeded:(NSString *) s {
    float oneLineHeight = [self heightForFont:self.captionLable.font];
    float totalHeight = [s boundingRectWithSize:CGSizeMake(self.captionLable.frame.size.width - 1 , CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.captionLable.font} context:nil].size.height;
    return nearbyint(totalHeight/oneLineHeight);
}

- (CGFloat)heightForFont:(UIFont *)font {
    CGSize size = [@"A" sizeWithAttributes:@{NSFontAttributeName:font}];
    return size.height;
}

- (NSString *)description:(NSString *)description maxLine:(NSInteger)lines {
    NSMutableString *truncatedString = [description mutableCopy];
    if ([self numberOfLinesNeeded:truncatedString] > lines) {
        if (truncatedString.length > 300) {
            NSRange range = NSMakeRange(0, 200);
            NSString *replaceStr = [description substringWithRange:range];
            truncatedString = [replaceStr mutableCopy];
        }
        [truncatedString appendString:space];
        [truncatedString appendString:ellipsis];
        NSRange range = NSMakeRange(truncatedString.length - (ellipsis.length + space.length + 1), 1);
        while ([self numberOfLinesNeeded:truncatedString] > lines) {
            [truncatedString deleteCharactersInRange:range];
            range.location--;
        }
        [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
        NSRange rangeOfTextMore = [truncatedString rangeOfString:[NSString stringWithFormat:@"%@%@",space,ellipsis] options:(NSBackwardsSearch)];
        [truncatedString deleteCharactersInRange:rangeOfTextMore];
    }
    return [truncatedString copy];
}


@end
