//
//  TKThumbnailView.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/16/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKThumbnailView.h"
#import "TKPhotoThumbnailCell.h"
@interface TKThumbnailView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation TKThumbnailView
@synthesize footerBackground = _footerBackground;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TKPhotoThumbnailCell" bundle:[NSBundle bundleForClass:[TKPhotoThumbnailCell class]]] forCellWithReuseIdentifier:@"TKPhotoThumbnailCell"];
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
   return [self.listThumbnail count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKPhotoThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TKPhotoThumbnailCell" forIndexPath:indexPath];
    cell.opactityView.backgroundColor = [self.footerBackground colorWithAlphaComponent:0.5];
    [cell setPhoto:self.listThumbnail[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    if (self.thumbnailDidChange) {
        self.thumbnailDidChange(self,_currentIndex);
    }
}

#pragma mark- Inir
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    if (![[self subviews] count]) {
        TKThumbnailView *loadedView = nil;
        loadedView = [[[NSBundle bundleForClass:[TKThumbnailView class]] loadNibNamed:@"TKThumbnailView" owner:nil options:nil] firstObject];
        loadedView.frame = self.frame;
        loadedView.autoresizingMask = self.autoresizingMask;
        loadedView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            id firstItem = constraint.firstItem;
            if (firstItem == self)
            {
                firstItem = loadedView;
            }
            id secondItem = constraint.secondItem;
            if (secondItem == self)
            {
                secondItem = loadedView;
            }
            [loadedView addConstraint:
             [NSLayoutConstraint constraintWithItem:firstItem
                                          attribute:constraint.firstAttribute
                                          relatedBy:constraint.relation
                                             toItem:secondItem
                                          attribute:constraint.secondAttribute
                                         multiplier:constraint.multiplier
                                           constant:constraint.constant]];
        }
        
        return loadedView;
    }
    return self;
}
#pragma mark-
- (void)setListThumbnail:(NSArray *)listThumbnail {
    
    [self setListThumbnail:listThumbnail atIndex:0];

}

- (void)setListThumbnail:(NSArray *)listThumbnail atIndex:(NSInteger)index {
    _listThumbnail = nil;
    _listThumbnail = listThumbnail;
    [self.collectionView reloadData];
        self.currentIndex = index;
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
