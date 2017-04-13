//
//  PickPhotoCollectionViewCell.m
//  GreenLands
//
//  Created by 刘乙灏 on 2017/4/5.
//  Copyright © 2017年 ricky. All rights reserved.
//

#import "PickPhotoCollectionViewCell.h"
#import "Masonry.h"
#import "LYHUIControl.h"

@implementation PickPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        [self addSubview:_imageView];
        
        CGFloat padding = 10;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(padding);
            make.right.bottom.equalTo(self).offset(-padding);
        }];
        _imageView.clipsToBounds = YES;
        
        _deleteView = [[UIView alloc] init];
        [self addSubview:_deleteView];
        [_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(padding * 2, padding * 2));
            make.top.equalTo(self);
            make.right.equalTo(self);
        }];
        _deleteView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnClick:)];
        [_deleteView addGestureRecognizer:tap];
        
        UILabel *deleteLabel = [LYHUIControl labelwithFont:[UIFont systemFontOfSize:8] textColor:[UIColor whiteColor] text:@"-"];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.backgroundColor = [UIColor redColor];
        deleteLabel.layer.cornerRadius = 5;
        deleteLabel.layer.masksToBounds = YES;
        [_deleteView addSubview:deleteLabel];
        [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_deleteView);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
    }
    return self;
}

- (void)deleteBtnClick:(UITapGestureRecognizer *)tap {
    _deleteViewClickBlock();
}

@end
