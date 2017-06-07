//
//  TKThumbnailView.h
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKThumbnailView : UIView
@property (nonatomic,strong) NSArray *listThumbnail;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic,strong) UIColor *footerBackground;
@property (nonatomic,copy)void (^thumbnailDidChange)(TKThumbnailView *view,NSInteger index);
- (void)setListThumbnail:(NSArray *)listThumbnail atIndex:(NSInteger)index;
@end
