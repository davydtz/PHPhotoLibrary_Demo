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
#define navHeight 54

@interface PhotoPickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *bigImagaeView;

@property (nonatomic, copy) NSArray *photoCollection;

//导航
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *navTitleBtn;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UITableView *navTableView;
@property (nonatomic, copy) NSArray *navImages;
@property (nonatomic, copy) NSArray *navTitles;


@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PhotoPickerViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomNavView];
    [self setupBigImageView];
    [self loadNavTableView];
    [self setupCollecionView];
    
}
-(void)setupCollecionView{
    
}
//加载相册
-(void)loadNavTableView{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    __block NSMutableArray *tmpImgArr = [NSMutableArray array];
    __block NSMutableArray *tmpTitleArr = [NSMutableArray array];
    
    
    for (PHAssetCollection *collection in fetchResult) {
        PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        if (assetResult.count != 0) {
            [tmpTitleArr addObject:collection.localizedTitle];
            PHAsset *latestAsset = [assetResult objectAtIndex:0];
            PHCachingImageManager *imgManager = [[PHCachingImageManager alloc] init];
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            [imgManager requestImageForAsset:latestAsset targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [tmpImgArr addObject:result];
                _navImages = [tmpImgArr copy];
                NSLog(@"%@--%@", NSStringFromCGSize(result.size), info);
            }];
        }
        _navTitles = [tmpTitleArr copy];
       
    }
    [_navTitleBtn setTitle:tmpTitleArr[0] forState:UIControlStateNormal];
    
    _navTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    [self.view addSubview:_navTableView];
    _navTableView.delegate = self;
    _navTableView.dataSource = self;
    //将谈了View放到navView的后面
    [self.view bringSubviewToFront:_navView];
}

//设置中间的大图片
-(void)setupBigImageView{
    _bigImagaeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.width)];
    _bigImagaeView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bigImagaeView];
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
    
    //标题
    _navTitleBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    [_navTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _navTitleBtn.center = CGPointMake(navView.frame.size.width/2, 30);
    [navView addSubview:_navTitleBtn];
    [_navTitleBtn setTitle:@"标题" forState:UIControlStateNormal];
    [_navTitleBtn addTarget:self action:@selector(showPhotoAlbums:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)showPhotoAlbums:(UIButton *)btn{
    btn.enabled = !btn.isEnabled;
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
    }];
}

-(void)cancelSelectAlbum:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.4 animations:^{
        tap.view.alpha = 0;
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        _navTitleBtn.enabled = YES;
    }];
    
}
@end
