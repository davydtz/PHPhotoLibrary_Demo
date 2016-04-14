//
//  PhotoCell.h
//  DDPhotoPicker
//
//  Created by Davy on 16/4/14.
//  Copyright © 2016年 Davy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) PHImageManager *imageManager;
@end
