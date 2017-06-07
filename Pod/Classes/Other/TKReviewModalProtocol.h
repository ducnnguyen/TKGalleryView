//
//  TKReviewModal.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKReviewModalProtocol <NSObject>
@required
- (NSString *) tk_fullPathImage;
@optional
- (NSString *)getThumbnail;
- (NSString *)getImage;
- (NSString *)getUrlImage;
- (NSString *)getComment;

@end
