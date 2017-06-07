//
//  TKCaptionProtocol.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/17/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKCaptionProtocol <NSObject>
@optional
- (NSInteger)ratting;
- (NSString *)reviewer;
- (NSString *)titleCaption;
- (NSString *)contentReview;
- (NSString *)dateReview;
- (BOOL)isLike;
- (BOOL)isDidBuy;
- (NSInteger)numberOfThanks;
@end
