//
//  TKDatasource.h
//  TKGalleryView
//
//  Created by Duc Nguyen on 6/9/17.
//  Copyright © 2017 duc.nguyen@tiki.vn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TKGalleryView/TKGalleryView.h>

@interface TKDatasource : NSObject<TKCaptionProtocol, TKReviewModalProtocol>
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithUrl:(NSString*)url;
@end
