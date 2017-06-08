//
//  TKTapDetectingView.h
//  TikiProject
//
//  Created by Duc Nguyen on 7/13/16.
//  Copyright © 2016 ABA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKTapDetectingViewDelegate;

@interface TKTapDetectingView : UIView {}

@property (nonatomic, weak) id <TKTapDetectingViewDelegate> tapDelegate;

@end

@protocol TKTapDetectingViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;

@end