//
//  PropertyRepairViewController.m
//  GreenLands
//
//  Created by 刘乙灏 on 2017/4/5.
//  Copyright © 2017年 ricky. All rights reserved.
//

#import "FormViewController.h"
#import "LYHPlaceholderTextView.h"
#import "PickPhotoCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"
#import "Define.h"
#import "LYHControl.h"

#define kIMAGE_COUNT 5

@interface FormViewController () <UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate, XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>
{
    __weak UIView *_contentView;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UICollectionView *photoPickCollectionView;
@property (nonatomic, copy) NSMutableArray *titleLabelArray;
@property (nonatomic, copy) NSArray *titleStringArray;
@property (nonatomic, copy) NSMutableArray *detailViewArray;
@property (nonatomic, copy) NSArray *detailPlaceholderArray;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSMutableArray *photoArray;
@property (nonatomic, copy) NSMutableArray *imageUrlArray;

@end

@implementation FormViewController

- (void)dealloc {
    
}

#pragma mark - View Lifecycle （View 的生命周期）

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"表单";
    
    [self.view addSubview:self.scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _contentView = contentView;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_scrollView);
        make.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.confirmBtn];
    
    [_contentView addSubview:self.backView];
    
    [self configLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - collectionView 代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellHeight, _cellHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.photoArray.count == kIMAGE_COUNT ? self.photoArray.count : self.photoArray.count + 1;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PickPhotoCollectionViewCell";
    PickPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    // 判断增加图片按钮还是图片预览
    if (indexPath.row == self.photoArray.count && self.photoArray.count < kIMAGE_COUNT) {
        cell.imageView.image = [UIImage imageNamed:@"添加照片"];
        cell.deleteView.hidden = YES;
    } else {
        cell.imageView.image = self.photoArray[indexPath.row];
        cell.deleteView.hidden = NO;
    }
    // 删除图片
    cell.deleteViewClickBlock = ^(void) {
        [self.photoArray removeObjectAtIndex:indexPath.row];
        [self resetPhotoPickCollectionViewHeight];
        [collectionView reloadData];
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photoArray.count && self.photoArray.count < kIMAGE_COUNT)
    {
        // 选择图片
        [self pickPhotoButtonClick:nil];
    } else {
        // 图片预览
        [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:self.photoArray.count datasource:self];
    }
}

#pragma mark - textview代理（placeholder显示隐藏、高度随内容变化）
/**
 *  判断placeholder显示隐藏
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    LYHPlaceholderTextView *tv = (LYHPlaceholderTextView *)textView;
    if ([text isEqualToString:@""] && range.length==1 && range.location==0) {
        [tv showPlaceholder];
    } else {
        [tv hidePlaceholder];
    }
    return YES;
}

/**
 *  设置textview高度随内容变化
 */
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newSize.height);
    }];
}

#pragma mark    -   XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    PickPhotoCollectionViewCell *cell = (PickPhotoCollectionViewCell *)[_photoPickCollectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView.image;
}

- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    PickPhotoCollectionViewCell *cell = (PickPhotoCollectionViewCell *)[_photoPickCollectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView;
}

#pragma mark - Event Response
- (void)confirmBtnClick:(UIButton *)btn {
    
    for (NSInteger i = 0; i < self.detailViewArray.count; i++) {
        UITextView * textView = self.detailViewArray[i];
        if (i == 3 && ![LYHControl checkPhoneNumber:textView.text]) { // 验证电话号码
            [LYHControl showAlertWithTitle:@"请输入正确的手机号" viewController:self buttonTitles:@"好的" block:^(UIAlertAction * _Nonnull action) {
                [textView becomeFirstResponder];
            }];
            return;
        } else if ([textView.text isEqualToString:@""]) {
            [LYHControl showAlertWithTitle:[NSString stringWithFormat:@"请填写%@", self.titleStringArray[i]] viewController:self buttonTitles:@"好的" block:^(UIAlertAction * _Nonnull action) {
                [textView becomeFirstResponder];
            }];
            return;
        }
    }
    
    [self.imageUrlArray removeAllObjects];
    [self uploadImageWithNum:0 andBtn:btn];
}

/**
 *  递归循环上传图片
 */
- (void)uploadImageWithNum:(NSInteger)num andBtn:(UIButton *)btn {
    
    if (!self.photoArray.count || num == self.photoArray.count) {
        // 图片上传成功或没有图片，提交表单
    } else {
        // 上传图片
        NSString *imageUrl=@"返回的imageUrl";
        [self.imageUrlArray addObject:imageUrl];
        [self uploadImageWithNum:(num + 1) andBtn:btn];
    }
}


#pragma mark TZImagePickerControllerDelegate 图片选择
- (void)pickPhotoButtonClick:(UIButton *)sender {
    
    //    [self presentViewController:[[ShareViewController alloc] init] animated:YES completion:nil];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(kIMAGE_COUNT - self.photoArray.count) delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *asssets, BOOL isSelectOriginalPhoto) {
    //
    //    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    //    [_contentTV becomeFirstResponder];
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.photoArray addObjectsFromArray:photos];
    
    [self resetPhotoPickCollectionViewHeight];
    [_photoPickCollectionView reloadData];
}

#pragma mark - Public

#pragma mark - Private
- (void)configLayout {
    CGFloat padding = 10;
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_contentView).offset(padding);
        make.right.bottom.equalTo(_contentView).offset(-padding);
    }];
    
    // 创建标题labels
    for (NSInteger i = 0; i < self.titleStringArray.count; i++) {
        UILabel *titleLabel = [LYHUIControl labelwithFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] text:self.titleStringArray[i]];
        [LYHControl conversionCharacterInterval:4 current:self.titleStringArray[i] withLabel:titleLabel];
        [_backView addSubview:titleLabel];
        [self.titleLabelArray addObject:titleLabel];
    }
    
    // 创建textview
    for (NSInteger i = 0; i < self.detailPlaceholderArray.count; i ++) {
        LYHPlaceholderTextView *detailView = [[LYHPlaceholderTextView alloc] init];
        detailView.delegate = self;
        detailView.layer.borderColor = [UIColor grayColor].CGColor;
        detailView.layer.borderWidth = 0.5;
        detailView.layer.cornerRadius = 3;
        detailView.layer.masksToBounds = YES;
        detailView.placeholderLabel.text = self.detailPlaceholderArray[i];
        [_backView addSubview:detailView];
        [self.detailViewArray addObject:detailView];
        
        if (i == 3) {
            detailView.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    // 标题布局
    for (NSInteger i = 0; i < self.titleLabelArray.count; i++) {
        UILabel *titleLabel = self.titleLabelArray[i];
        if (i == 0) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_backView).offset(padding * 2);
                make.left.equalTo(_backView).offset(padding);
                make.height.mas_equalTo(25);
            }];
        } else {
            UIView *detailView = self.detailViewArray[i - 1];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailView.mas_bottom).offset(padding * 2);
                make.left.equalTo(_backView).offset(padding);
                make.height.mas_equalTo(25);
            }];
        }
        [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    // textview布局
    for (NSInteger i = 0; i < self.detailViewArray.count; i++) {
        UIView *detailView = self.detailViewArray[i];
        UILabel *titleLabel = self.titleLabelArray[i];
        [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right).offset(padding);
            make.right.equalTo(_backView).offset(-padding);
            make.height.mas_equalTo(25);
        }];
    }
    
    [_backView addSubview:self.photoPickCollectionView];
    
    UILabel *lastTitleLabel = self.titleLabelArray.lastObject;
    [_photoPickCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTitleLabel).offset(0);
        make.left.equalTo(lastTitleLabel.mas_right).offset(padding);
        make.right.equalTo(_backView).offset(-padding);
        make.bottom.equalTo(_backView).offset(-padding);
    }];
    
    [_backView layoutIfNeeded];
    
    _cellHeight = (_photoPickCollectionView.frame.size.width) / 3;
    [_photoPickCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_cellHeight);
    }];
    [_photoPickCollectionView reloadData];
}

/**
 *  选择图片后，改变图片预览collectionview高度适应
 */
- (void)resetPhotoPickCollectionViewHeight {
    CGFloat height = self.photoArray.count >= 3 ? 2 * _cellHeight + 10 : _cellHeight;
    [_photoPickCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - IBActions

#pragma mark - Getter and Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [LYHUIControl buttonWithTitle:@"提交报修" font:[UIFont systemFontOfSize:15] target:self action:@selector(confirmBtnClick:) normalColor:[UIColor whiteColor]];
        _confirmBtn.backgroundColor = [UIColor blueColor];
    }
    return _confirmBtn;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _backView;
}

- (UICollectionView *)photoPickCollectionView {
    if (!_photoPickCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _photoPickCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoPickCollectionView.backgroundColor = [UIColor whiteColor];
        _photoPickCollectionView.scrollEnabled = NO;
        _photoPickCollectionView.dataSource = self;
        _photoPickCollectionView.delegate = self;
        [_photoPickCollectionView registerClass:[PickPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PickPhotoCollectionViewCell"];
    }
    return _photoPickCollectionView;
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (NSArray *)titleStringArray {
    if (!_titleStringArray) {
        _titleStringArray = @[@"报修地址", @"报修人", @"报修物品", @"联系电话", @"报修详情", @"添加图片"];
    }
    return _titleStringArray;
}

- (NSMutableArray *)detailViewArray {
    if (!_detailViewArray) {
        _detailViewArray = [NSMutableArray array];
    }
    return _detailViewArray;
}

- (NSArray *)detailPlaceholderArray {
    if (!_detailPlaceholderArray) {
        _detailPlaceholderArray = @[@"填写报修单位与地址", @"填写报修人姓名", @"填写报修物品", @"填写联系人电话", @"填写报修详情"];
    }
    return _detailPlaceholderArray;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

@end
