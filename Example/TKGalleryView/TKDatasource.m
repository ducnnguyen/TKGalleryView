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

@end
