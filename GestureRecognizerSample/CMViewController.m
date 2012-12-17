//
//  CMViewController.m
//  GestureRecognizerSample
//
//  Created by KAKEGAWA Atsushi on 2012/12/16.
//  Copyright (c) 2012年 KAKEGAWA Atsushi. All rights reserved.
//

#import "CMViewController.h"
#import "CMDoubleTapAndPanGestureRecognizer.h"

@interface CMViewController ()

@end

@implementation CMViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    // UIImageViewにイメージをセット
	UIImage *image = [UIImage imageNamed:@"image.jpg"];
    self.imageView.image = image;
    // frameのサイズをセットしたイメージの解像度に合わせる
    CGPoint imageViewOrigin = self.imageView.frame.origin;
    self.imageView.frame = CGRectMake(imageViewOrigin.x, imageViewOrigin.y, image.size.width, image.size.height);
    
    // 最小スケールは縦も横もUIScrollViewのboundsに収まる大きさ
    CGFloat minWidthScale = self.scrollView.bounds.size.width / self.imageView.frame.size.width;
    CGFloat minHeightScale = self.scrollView.bounds.size.height / self.imageView.frame.size.height;
    self.scrollView.minimumZoomScale = MIN(minWidthScale, minHeightScale);
    self.scrollView.maximumZoomScale = 3.0f;
    // 初期状態は最小スケールにして画像が全て見えるようにする
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    // Google Maps風のジェスチャの追加
    CMDoubleTapAndPanGestureRecognizer *gesture =
    [[CMDoubleTapAndPanGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(handleDoubleTapAndPanGesture:)];
    [self.scrollView addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // イメージの表示サイズがUIScrollViewのboundsより小さい場合、センタリングするようにする
    
    CGPoint imageViewOrigin = self.imageView.frame.origin;
    CGFloat imageViewOriginX = imageViewOrigin.x;
    CGFloat imageViewOriginY = imageViewOrigin.y;
    
    CGSize imageViewSize = self.imageView.frame.size;
    
    if (imageViewSize.width < self.scrollView.bounds.size.width) {
        imageViewOriginX = CGRectGetMidX(self.scrollView.frame) - imageViewSize.width * 0.5f;
    } else {
        imageViewOriginX = 0.0f;
    }
    
    if (imageViewSize.height < self.scrollView.bounds.size.height) {
        imageViewOriginY = CGRectGetMidY(self.scrollView.frame) - imageViewSize.height * 0.5f;
    } else {
        imageViewOriginY = 0.0f;
    }
    
    self.imageView.frame = CGRectMake(imageViewOriginX, imageViewOriginY, imageViewSize.width, imageViewSize.height);
}

#pragma mark - Handlers

- (void)handleDoubleTapAndPanGesture:(CMDoubleTapAndPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        // 現在のスケールにジェスチャによる倍率を乗算
        self.scrollView.zoomScale = self.scrollView.zoomScale * gesture.scale;
    }
}

@end
