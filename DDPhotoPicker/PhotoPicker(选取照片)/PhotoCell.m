//
//  PhotoCell.m
//  DDPhotoPicker
//
//  Created by Davy on 16/4/14.
//  Copyright © 2016年 Davy. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addImageView];
        _imageManager = [[PHImageManager alloc] init];
    }
    return self;
}

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    [_imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.frame.size.width, self.frame.size.height) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        _imageView.image = result;
    }];
}

-(void)addImageView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.contentView addSubview:_imageView];
    _imageView.backgroundColor = [UIColor grayColor];
}
@end
