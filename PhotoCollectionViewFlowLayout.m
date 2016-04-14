//
//  PhotoCollectionViewFlowLayout.m
//  DDPhotoPicker
//
//  Created by Davy on 16/4/14.
//  Copyright © 2016年 Davy. All rights reserved.
//

#import "PhotoCollectionViewFlowLayout.h"

@implementation PhotoCollectionViewFlowLayout

-(instancetype)init{
    if (self = [super init]) {
        CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - 2*3)/4;
        self.itemSize = CGSizeMake(itemW, itemW);
        self.minimumInteritemSpacing = 2;
        self.minimumLineSpacing = 2;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;    
}


@end
