//
//  PickPhotoCollectionViewCell.h
//  GreenLands
//
//  Created by 刘乙灏 on 2017/4/5.
//  Copyright © 2017年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deleteViewClickBlock)(void);

@interface PickPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *deleteView;

@property (nonatomic, copy) deleteViewClickBlock deleteViewClickBlock;

@end
