//
//  UIView+PodBundle.m
//  Pods
//
//  Created by Duc Nguyen on 6/12/17.
//
//

#import "UIView+PodBundle.h"

@implementation UIView (PodBundle)
+ (instancetype)viewFromPodNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[self.class class]];
    NSURL *bundleURL = [podBundle URLForResource:@"TKGalleryView" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSArray *topLevelObjects = [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[self class]]) {
            return currentObject;
        }
    }
    return nil;

}
@end
