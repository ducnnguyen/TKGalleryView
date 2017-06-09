//
//  TKCaptionView.m
//  TKPhotoLibary
//
//  Created by ZickOne on 11/15/16.
//  Copyright © 2016 ZickOne. All rights reserved.
//

#import "TKCaptionView.h"
#import "HCSStarRatingView.h"
#import "TKCaptionTitleCell.h"
#import "TKCaptionDescriptionCell.h"
#import "ReactiveCocoa.h"

#define  kDefaultHeightTableCell 50
@interface TKCaptionView() <UITableViewDelegate,UITableViewDataSource> {
    float _heightDescrption;
}
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusBuy;
@property (weak, nonatomic) IBOutlet UITextView *contentString;
@property (weak, nonatomic) IBOutlet UILabel *captionTitle;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rattingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyStatusLayoutContrains;
@property (weak, nonatomic) IBOutlet UIButton *btnThanks;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *nameAndDate;
@property (nonatomic,strong) id<TKCaptionProtocol> captionObj;
@property (nonatomic) float heightDescrption;
@end
@implementation TKCaptionView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _heightDescrption = kDefaultHeightTableCell;
    [self.labelStatusBuy.layer setBorderWidth:1];
    [self.labelStatusBuy.layer setBorderColor:[UIColor colorWithRed:251/255.f green:130/255.f blue:39/255.f alpha:1].CGColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"TKCaptionTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TKCaptionTitleCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"TKCaptionDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TKCaptionDescriptionCell"];
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UITapGestureRecognizer *tapabc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTableView:)];
    [self.tableview addGestureRecognizer:tapabc];
}

- (void)didTapTableView:(id)sender {
   
    
    _heightDescrption = kDefaultHeightTableCell;
    if (self.didExpand) {
        self.didExpand(NO,kDefaultHeightTableCell,self.tableview);
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TKCaptionDescriptionCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell setCaption:[self.captionObj contentReview] shouldExpand:NO] ;
        [self.tableview reloadData];

    });

}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    
    if (![[self subviews] count]) {
        TKCaptionView *loadedView = nil;
        loadedView = [[[NSBundle mainBundle] loadNibNamed:@"TKCaptionView" owner:nil options:nil] firstObject];
        loadedView.frame = self.frame;
        loadedView.autoresizingMask = self.autoresizingMask;
        loadedView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        loadedView.clipsToBounds = NO;
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

- (IBAction)showFullCaption:(id)sender {
    if (self.didShowFullCaption) {
        self.didShowFullCaption(self.contentString);
    }
}
- (IBAction)didClickThanks:(id)sender {
    if (self.didClickThanks) {
        self.didClickThanks();
    }
}
- (IBAction)didClickComment:(id)sender {
    if (self.didReply) {
        self.didReply();
    }
}

- (void)setShowCaption:(id<TKCaptionProtocol>)caption {
    self.captionObj = caption;
    [self.tableview reloadData];
    NSString *title = @"Cảm ơn";
    if ([caption numberOfThanks] > 0) {
        title = [NSString stringWithFormat:@"%lu Cảm ơn",[caption numberOfThanks]];
    }
    [self.btnThanks setTitle:title forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return  _heightDescrption;
    }
    return 36;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.row == 0) {
        TKCaptionTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"TKCaptionTitleCell" forIndexPath:indexPath];
        [titleCell setStart:[self.captionObj ratting] title:[self.captionObj titleCaption]];
        return titleCell;
    } else if (indexPath.row == 1) {
        TKCaptionDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"TKCaptionDescriptionCell" forIndexPath:indexPath];
        
        BOOL isExpand =  _heightDescrption == kDefaultHeightTableCell ? NO : YES;
        
        [descriptionCell setCaption:[self.captionObj contentReview] shouldExpand:isExpand] ;
        
        [descriptionCell setDidExpand:^(BOOL isExpandLocal , float newHeight) {
            @strongify(self);
            _heightDescrption = newHeight;
            if (isExpandLocal) {
                [self.tableview reloadData];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TKCaptionDescriptionCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    [cell setCaption:[self.captionObj contentReview] shouldExpand:NO] ;
                    [self.tableview reloadData];
                    
                });
            }
            if (self.didExpand) {
                self.didExpand(isExpandLocal,_heightDescrption,self.tableview);
            }
        }];
        return descriptionCell;
    }
    
    return nil;
}

@end
