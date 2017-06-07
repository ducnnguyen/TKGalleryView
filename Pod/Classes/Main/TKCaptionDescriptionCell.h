//
//  TKCaptionDescriptionCell.h
//  TikiProject
//
//  Created by ZickOne on 11/29/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKCaptionDescriptionCell : UITableViewCell
@property (nonatomic,strong)void(^didExpand)(BOOL isExpand , float newHeight);
@property (nonatomic) BOOL expand;
- (void)setCaption:(NSString *)text;
-(int)numberOfLinesNeeded:(NSString *) s;
- (void)setCaption:(NSString *)text shouldExpand:(BOOL)isExpand;
- (CGFloat)heightForFont:(UIFont *)font;
@end
