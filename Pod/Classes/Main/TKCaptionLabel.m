//
//  TKCaptionLabel.m
//  TikiProject
//
//  Created by ZickOne on 11/29/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import "TKCaptionLabel.h"
#define kNumberOfLines 2
#define ellipsis @"...Xem thêm"
@implementation TKCaptionLabel {
    NSString *string;
}

#pragma Public Methods

- (void)setTruncatingText:(NSString *) txt {
    [self setTruncatingText:txt forNumberOfLines:kNumberOfLines];
}

- (void)setTruncatingText:(NSString *) txt forNumberOfLines:(int) lines{
    string = txt;
    self.numberOfLines = 0;
    NSMutableString *truncatedString = [txt mutableCopy];
    if ([self numberOfLinesNeeded:truncatedString] > lines) {
        [truncatedString appendString:ellipsis];
        NSRange range = NSMakeRange(truncatedString.length - (ellipsis.length + 1), 1);
        while ([self numberOfLinesNeeded:truncatedString] > lines) {
            [truncatedString deleteCharactersInRange:range];
            range.location--;
        }
        [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
        CGRect labelFrame = self.frame;
        labelFrame.size.height =  [self heightForFont:self.font] * lines;
        self.frame = labelFrame;
        self.text = truncatedString;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
        [self addGestureRecognizer:tapper];
    }else{
        CGRect labelFrame = self.frame;
        labelFrame.size.height =  [self heightForFont:self.font] * lines;
        self.frame = labelFrame;
        self.text = txt;
    }
}


#pragma Private Methods

-(int)numberOfLinesNeeded:(NSString *) s {
    float oneLineHeight = [self heightForFont:self.font];
    float totalHeight = [s boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil].size.height;
    return nearbyint(totalHeight/oneLineHeight);
}

-(void)expand:(UITapGestureRecognizer *) tapper {
    int linesNeeded = [self numberOfLinesNeeded:string];
    CGRect labelFrame = self.frame;
    labelFrame.size.height = [self heightForFont:self.font] * linesNeeded;
    self.frame = labelFrame;
    self.text = string;
}
- (CGFloat)heightForFont:(UIFont *)font {
    CGSize size = [@"A" sizeWithAttributes:@{NSFontAttributeName:font}];
    return size.height;
}
@end
