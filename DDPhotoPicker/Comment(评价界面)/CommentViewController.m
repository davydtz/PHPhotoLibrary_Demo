//
//  CommentViewController.m
//  DDPhotoPicker
//
//  Created by Davy on 16/4/9.
//  Copyright © 2016年 Davy. All rights reserved.
//

#import "CommentViewController.h"
#import "PhotoPickerViewController.h"
@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *chooseImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    chooseImageBtn.adjustsImageWhenHighlighted = NO;
    [chooseImageBtn setImage:[UIImage imageNamed:@"bsorderrate_camera"] forState:UIControlStateNormal];
    [self.view addSubview:chooseImageBtn];
    [chooseImageBtn addTarget:self action:@selector(showPhotoPickerVC) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showPhotoPickerVC{
    PhotoPickerViewController *photoPickerVC = [PhotoPickerViewController new];
    [self presentViewController:photoPickerVC animated:YES completion:NO];
}
@end
