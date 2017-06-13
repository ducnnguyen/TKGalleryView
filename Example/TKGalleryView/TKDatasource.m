//
//  TKDatasource.m
//  TKGalleryView
//
//  Created by Duc Nguyen on 6/9/17.
//  Copyright © 2017 duc.nguyen@tiki.vn. All rights reserved.
//

#import "TKDatasource.h"

@implementation TKDatasource
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (NSString *) tk_fullPathImage {
    return self.url;
}
- (NSInteger)numberOfThanks {
    return 0;
}
- (NSInteger) rating {
    return 5;
}
- (NSString*) reviewer {
    return @"Duc Nguyen";
}
- (NSString*) titleCaption {
    return @"Nguyen Ngoc Duc";
}
- (NSString*) contentReview {
    return @"Nguyen Ngoc Duc Da nhan xet nhan xet nay";
}
- (NSString*) dateReview {
    return @"Yesteday";
}
- (BOOL)isLike {
    return YES;
}
- (BOOL)isDidBuy {
    return NO;
}


@end
