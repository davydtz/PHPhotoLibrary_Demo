//
//  PhotoPickerViewController.m
//  DDPhotoPicker
//
//  Created by Davy on 16/4/9.
//  Copyright © 2016年 Davy. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHCollection.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>
#import "PhotoCollectionViewFlowLayout.h"
#import "PhotoCell.h"
#define navHeight 54
static int rotationCount = 0;
@interface PhotoPickerViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *bigImagaeView;

@property (nonatomic, copy) NSArray *photoCollection;

//导航
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *navTitleBtn;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UITableView *navTableView;
@property (nonatomic, copy) NSArray *navImages;
@property (nonatomic, copy) NSArray *navTitles;

//照片
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) PHAssetCollection *currentAlbum; //当前选中的相册
@property (nonatomic, strong) NSArray *allAlbums; //所有的相册
@property (nonatomic, strong) PHImageManager *imgManager;
@end

@implementation PhotoPickerViewController


-(PHImageManager *)imgManager{
    if (!_imgManager) {
        _imgManager = [[PHImageManager alloc] init];
    }
    return _imgManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomNavView];
    [self setupBigImageView];
    [self loadNavTableView];
    [self setupCollecionView];
    
}

-(void)setupCollecionView{
    PhotoCollectionViewFlowLayout *flowLayout = [[PhotoCollectionViewFlowLayout alloc] init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width+navHeight+50, self.view.frame.size.width, self.view.frame.size.height-navHeight-self.view.frame.size.width-50) collectionViewLayout:flowLayout];

    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    [self.view addSubview:_photoCollectionView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.width+navHeight, self.view.frame.size.width, 50)];
    [self.view addSubview:toolBar];
    toolBar.translucent = YES;
    toolBar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *itemRotate = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bs_imageedit_rotate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(ratateImage)];
    UIBarButtonItem *itemChangeImageContentMode = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bs_imageedit_fit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(changeImageContentMode)];
    [toolBar setItems:@[itemRotate, itemChangeImageContentMode]];
}

-(void)ratateImage{
    [UIView animateWithDuration:0.5 animations:^{
        rotationCount++;
        _bigImagaeView.transform = CGAffineTransformMakeRotation(-M_PI_2 * rotationCount);
    } completion:^(BOOL finished) {
//        _bigImagaeView.image = [self image:_bigImagaeView.image rotation:UIImageOrientationLeft];
    }];
}


-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation

{
    
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate = M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = 0;
            
            translateY = -rect.size.width;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate = 3 * M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = -rect.size.height;
            
            translateY = 0;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate = M_PI;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = -rect.size.width;
            
            translateY = -rect.size.height;
            
            break;
            
        default:
            
            rotate = 0.0;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = 0;
            
            translateY = 0;
            
            break;
            
    }
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX, translateY);
    
    
    
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    return newPic;
    
}

-(void)changeImageContentMode{
    if (_bigImagaeView.contentMode == UIViewContentModeScaleAspectFit) {
        _bigImagaeView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        _bigImagaeView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

//加载所有的相册
-(void)loadNavTableView{
    PHFetchResult *tmpResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    _allAlbums =
    
    __block NSMutableArray *tmpImgArr = [NSMutableArray array];
    __block NSMutableArray *tmpTitleArr = [NSMutableArray array];
    __block NSMutableArray *tmpAlbumArr = [NSMutableArray array]; //暂时的相册列表
    [tmpResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetResult.count != 0) {
            [tmpAlbumArr addObject:collection];
            [tmpTitleArr addObject:[NSString stringWithFormat:@"%@(%lu)", collection.localizedTitle, (unsigned long)assetResult.count]];
            PHAsset *latestAsset = [assetResult objectAtIndex:0];
            PHCachingImageManager *imgManager = [[PHCachingImageManager alloc] init];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [self.imgManager requestImageForAsset:latestAsset targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [tmpImgArr addObject:result];
                _navImages = [tmpImgArr copy];
            }];
        }
    }];
    _navTitles = [tmpTitleArr copy];
    _allAlbums = [tmpAlbumArr copy];
    [_navTitleBtn setTitle:tmpTitleArr[0] forState:UIControlStateNormal];
    
    _navTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    [self.view addSubview:_navTableView];
    _navTableView.hidden = YES;
    _navTableView.delegate = self;
    _navTableView.dataSource = self;
    //将谈了View放到navView的后面
    [self.view bringSubviewToFront:_navView];
    _currentAlbum = [_allAlbums objectAtIndex:0];
}

//设置中间的大图片
-(void)setupBigImageView{
    _bigImagaeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:_bigImagaeView];
    _bigImagaeView.clipsToBounds = YES;
}

//设置导航UI
-(void)setCustomNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navHeight)];
    [self.view addSubview:navView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, navView.frame.size.width, 3)];
    imageView.image = [UIImage imageNamed:@"tmbuy_address_line"];
    [navView addSubview:imageView];
    
    UIButton *navBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 18, 35, 35)];
    [navBackBtn setImage:[UIImage imageNamed:@"shop_detailhead_return-1"] forState:UIControlStateNormal];
    [navView addSubview:navBackBtn];
    [navBackBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //标题
    _navTitleBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    [_navTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _navTitleBtn.center = CGPointMake(navView.frame.size.width/2, 30);
    [navView addSubview:_navTitleBtn];
    [_navTitleBtn setTitle:@"标题" forState:UIControlStateNormal];
    [_navTitleBtn addTarget:self action:@selector(showPhotoAlbums:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showPhotoAlbums:(UIButton *)btn{
    btn.enabled = !btn.isEnabled;
    _navTableView.hidden = !_navTableView.isHidden;
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.bounds.size.width, self.view.bounds.size.height-navHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectAlbum:)];
    [_shadowView addGestureRecognizer:tap];
    [self.view addSubview:_shadowView];
    [self.view bringSubviewToFront:_navTableView];
    
    [UIView animateWithDuration:0.4 animations:^{
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 200+navHeight);
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _navTitles.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = _navTitles[indexPath.row];
    cell.imageView.image = _navImages[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.4 animations:^{
        _shadowView.alpha = 0;
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [_shadowView removeFromSuperview];
        _navTitleBtn.enabled = YES;
        _navTableView.hidden = YES;
    }];
    _currentAlbum = _allAlbums[indexPath.row];
    [_photoCollectionView reloadData];
}

-(void)cancelSelectAlbum:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.4 animations:^{
        tap.view.alpha = 0;
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        _navTitleBtn.enabled = YES;
        _navTableView.hidden = YES;
    }];
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
    [self.imgManager requestImageDataForAsset:assetResult[0] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        _bigImagaeView.image = image;
    }];
    return assetResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
    cell.asset = result[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
    [self.imgManager requestImageDataForAsset:assetResult[indexPath.row] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        _bigImagaeView.image = image;
    }];
}
@end
