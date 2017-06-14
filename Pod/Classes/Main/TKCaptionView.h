//
//  TKCaptionView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/15/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCaptionProtocol.h"
@interface TKCaptionView : UIView

@property (nonatomic, copy) void (^didShowFullCaption)(UITextView* content);
@property (nonatomic, copy) void (^didClickThanks)();
@property (nonatomic, copy) void (^didReply)();
@property (nonatomic, copy) void (^didExpand)(BOOL isExpand,float newHeight,UITableView *tableview);

- (void)setShowCaption:(id<TKCaptionProtocol>)caption;

@end
