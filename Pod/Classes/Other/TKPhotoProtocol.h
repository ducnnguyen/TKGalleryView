//
//  TKPhotoProtocol.h
//  TikiProject
//
//  Created by Duc Nguyen on 7/13/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
#define TKPHOTO_LOADING_DID_END_NOTIFICATION @"TKPHOTO_LOADING_DID_END_NOTIFICATION"
#define TKPHOTO_PROGRESS_NOTIFICATION @"TKPHOTO_PROGRESS_NOTIFICATION"

@protocol TKPhotoProtocol <NSObject>

@required

@property (nonatomic, strong) UIImage *underlyingImage;

- (void)loadUnderlyingImageAndNotify;

- (void)performLoadUnderlyingImageAndNotify;

- (void)unloadUnderlyingImage;

@optional

// If photo is empty, in which case, don't show loading error icons
@property (nonatomic) BOOL emptyImage;

// Cancel any background loading of image data
- (void)cancelAnyLoading;

@end
