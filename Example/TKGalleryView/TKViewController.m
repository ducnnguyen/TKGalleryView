//
//  TKViewController.m
//  TKGalleryView
//
//  Created by duc.nguyen@tiki.vn on 06/06/2017.
//  Copyright (c) 2017 duc.nguyen@tiki.vn. All rights reserved.
//

#import "TKViewController.h"
#import "TKCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TKDatasource.h"
#import <TKGalleryView/TKGalleryView.h>

@interface TKViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasources;

@end

@implementation TKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.collectionView registerNib:[UINib nibWithNibName:@"TKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TKCollectionViewCell"];
    NSArray *datasources = @[@"http://68.media.tumblr.com/c081f03eed64c2fc7e44c5302629c9e0/tumblr_oqphqntx3W1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/4f648fb365c1501f91d3b3cb9415dcf0/tumblr_oqi1tr4Wpb1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/126ac5aa7f2ac01ff40c5ddc4aa5dc88/tumblr_oq9eestVEW1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/ff4da737ef8c1485de69310332cc5298/tumblr_oq9eeoLngA1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/13d23b5e402069f9cb2bf7a02b0c89f5/tumblr_oq9eemh7Z91qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/cc3475c196cd02ed14394c2125fbe1df/tumblr_oq2xixXJPw1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/865e61cdf8d44c252ee83e0a271b8434/tumblr_oq2xiuwSNI1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/023b3f8c53c3c42b68de422961b083cc/tumblr_oq057uTo5H1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/5105f78bae0b1c5a5f2851ccdd0eb189/tumblr_oq057rkkcT1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/2e92492b4ef515124540a47aeb987e07/tumblr_oq057oN7le1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/edeadaccf64e60c133825f51cf6c08f6/tumblr_oq057fCxeC1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/e8dadc184fe67cb00511e3e243f5513f/tumblr_oq057bxGTL1qbd81ro1_1280.jpg",
                         @"http://68.media.tumblr.com/c2b359d90b868247565a37b4f70ea2d9/tumblr_omu6agTv6b1qbd81ro1_1280.jpg"];
    self.datasources = [NSMutableArray array];
    [datasources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TKDatasource *source = [[TKDatasource alloc] initWithUrl:obj];
        [self.datasources addObject:source];
    }];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasources.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKCollectionViewCell *cell = (TKCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"TKCollectionViewCell" forIndexPath:indexPath];
    TKDatasource *source = self.datasources[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:source.url]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TKGalleryViewController *galleryView = [[TKGalleryViewController alloc] init];
    galleryView.datasource = self;
    galleryView.delegate = self;
}
@end
