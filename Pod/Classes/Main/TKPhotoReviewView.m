//
//  TKPhotoReviewView.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/14/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKPhotoCollectionViewCell.h"
#import "TKReviewModalProtocol.h"
#import "TKPhotoReviewFlowLayout.h"
#import "TKCaptionView.h"
#import "TKPhotoReviewView.h"
#import "ReactiveCocoa.h"
#import "UIView+PodBundle.h"
#import "Masonry.h"

@interface TKPhotoReviewView() <UICollectionViewDataSource> {

}
@property (strong, nonatomic) TKCaptionView *captionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *backgroundAnimationView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCaptionContrains;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBackgroudContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginParentContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightbgView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *parentCaptionView;

@end

@implementation TKPhotoReviewView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (TKCaptionView*)captionView {
    if (_captionView == nil) {
        _captionView = [TKCaptionView viewFromPodNib];
        [self.parentCaptionView addSubview:_captionView];
        [_captionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        @weakify(self)
        [_captionView setDidReply:^{
            @strongify(self)
            if (self.didReply) {
                self.didReply();
            }
        }];
        [_captionView setDidClickThanks:^{
            @strongify(self)
            if (self.didClickThanks) {
                self.didClickThanks();
            }
        }];
    }
    return _captionView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[TKPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"TKPhotoCollectionViewCell"];
    @weakify(self);
   
    [self.captionView setDidExpand:^(BOOL isExpand,float newHeigh,UITableView *tableview) {
        @strongify(self);
        if (isExpand) {
            self.heightbgView.constant = self.frame.size.height;
            [self.backgroundAnimationView setAlpha:0];
            [self layoutIfNeeded];

            [UIView animateWithDuration:0.33 animations:^{
                self.heightBackgroudContrain.constant = self.frame.size.height;
                [self.backgroundAnimationView setAlpha:1];
                float height = self.frame.size.height - (newHeigh + 60 );
                height = MAX(60, height);
                [tableview setContentInset:(UIEdgeInsetsMake(height, 0, 0, 0))];
                [self layoutIfNeeded];
            }];
        } else {
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.33 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
                [self.backgroundAnimationView setAlpha:0];
                self.heightBackgroudContrain.constant = 115;
                [tableview setContentInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
                [self layoutIfNeeded];

            } completion:^(BOOL finished) {
                self.heightbgView.constant = 115;
                [self.backgroundAnimationView setAlpha:1];

            }];

        }
    }];
    self.backgroundColor = self.contentBackground;
}
- (void)setBtnTintColor:(UIColor *)btnTintColor {
    self.btnClose.tintColor = btnTintColor;
    [self.btnClose setImage:[[UIImage imageNamed:@"Close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:(UIControlStateNormal)];
}

- (void)setDatasource:(id<TKGalleryViewDatasource>)datasource {
    _datasource = datasource;
    _currentIndex = 0;
//    self.gallery.isShowCaption = NO;
    self.captionView.hidden = !self.gallery.isShowCaption;
    self.backgroundView.hidden = !self.gallery.isShowCaption;
    self.parentCaptionView.hidden = !self.gallery.isShowCaption;
    if (self.gallery.isShowCaption) {
        [_captionView setShowCaption:[self.datasource gallery:self.gallery itemAtIndex:_currentIndex]];
    }
    [self.collectionView setAlpha:0];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    [UIView animateWithDuration:0.33  delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.collectionView setAlpha:1];
    } completion:nil];
}



- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        if (self.gallery.isShowCaption) {
            [_captionView setShowCaption:[self.datasource gallery:self.gallery itemAtIndex:_currentIndex]];
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    }
}

- (TKPhotoCollectionViewCell *)viewIsVisible {
    return [[self.collectionView visibleCells] lastObject];
}

//- (void)thankReview:(PhotoReview*)photoReview atIndex:(NSInteger)index {
//    @weakify(self);
//    [ApiEngine thankAReview:photoReview.review.identifier onComplete:^{
//        @strongify(self);
//        photoReview.review.thankCount ++;
//        [self.captionView setShowCaption:photoReview];
//    } onFailure:^(NSString *error) {
//        
//    }];
//}

#pragma mark- CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.datasource) {
        return [self.datasource numberOfPhotos:self.gallery];
    }
    return 0;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TKPhotoCollectionViewCell" forIndexPath:indexPath];
    id <TKReviewModalProtocol> photoReviews = [self.datasource gallery:self.gallery itemAtIndex:indexPath.row];
    [cell setPhoto:photoReviews];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = [UIScreen mainScreen].bounds;
    return CGSizeMake(frame.size.width, frame.size.height - 72);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

#pragma mark- ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint currentPoint = scrollView.contentOffset;
    NSIndexPath *indexPath = [self indexPathForCollectionView:self.collectionView Point:currentPoint];
    _currentIndex = indexPath.row;
    [_captionView setShowCaption:[self.datasource gallery:self.gallery itemAtIndex:_currentIndex]];
    if (self.photoReviewDidChange) {
        self.photoReviewDidChange(self,self.currentIndex);
    }
}

#pragma mark-
- (NSIndexPath *)indexPathForCollectionView:(UICollectionView *)collectionView Point:(CGPoint)point {
    NSArray *listAttribute =  [collectionView.collectionViewLayout layoutAttributesForElementsInRect:collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attribute in listAttribute) {
        if (attribute.representedElementKind == nil  && CGRectContainsPoint(attribute.frame, point)) {
            //Caculator source rect
            if (attribute.representedElementKind == nil) {
                NSIndexPath *indexPath = attribute.indexPath;
                return indexPath;
            }
        }
    }
    return nil;
}

- (IBAction)didClickBtnClose:(id)sender {
    if (self.didClose) {
        self.didClose();
    }
}


- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.3 : 0) animations:^(void) {
        CGFloat alpha = hidden ? 0 : 1;
        self.captionView.alpha = alpha;
        self.btnClose.alpha = alpha;
        self.backgroundView.alpha = alpha;
        self.parentCaptionView.alpha = alpha;
        self.backgroundAnimationView.alpha = alpha;
    } completion:nil];
}

- (BOOL)isHiddenCaption {
    return self.captionView.alpha;
}
@end
