//
//  TKThumbnailView.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKThumbnailView.h"
#import "TKPhotoThumbnailCell.h"
#import "UIView+PodBundle.h"
#import "TKGalleryDelegateAndDatasource.h"
#import "TKGalleryViewController.h"

@interface TKThumbnailView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TKThumbnailView

@synthesize footerBackground = _footerBackground;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TKPhotoThumbnailCell" bundle:[TKPhotoThumbnailCell podBundle]] forCellWithReuseIdentifier:@"TKPhotoThumbnailCell"];
}

- (UIColor *)footerBackground {
    return _footerBackground != nil ? _footerBackground : [UIColor blackColor];
}

- (void)setFooterBackground:(UIColor *)footerBackground {
    _footerBackground = footerBackground;
    self.backgroundColor = footerBackground;
    self.collectionView.backgroundColor = footerBackground;
}

#pragma mark- CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfPhotos:)]) {
        return [self.datasource numberOfPhotos:self.gallery];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKPhotoThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TKPhotoThumbnailCell" forIndexPath:indexPath];
    cell.opactityView.backgroundColor = [self.footerBackground colorWithAlphaComponent:0.5];
    id item = [self.datasource gallery:self.gallery itemAtIndex:indexPath.row];
    [cell setPhoto:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    if (self.thumbnailDidChange) {
        self.thumbnailDidChange(self,_currentIndex);
    }
}

#pragma mark-
- (void)setDatasource:(id<TKGalleryViewDatasource>)datasource {
    _datasource = datasource;
    [self.collectionView reloadData];
    self.currentIndex = 0;
}



- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    NSIndexPath *indexPath = [indexPaths firstObject];
    if (!indexPath) {
        indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    }
    [self.collectionView  selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionLeft)];
}
@end
