//
//  CMDoubleTapAndPanGestureRecognizer.m
//  GestureRecognizerSample
//
//  Created by KAKEGAWA Atsushi on 2012/12/16.
//  Copyright (c) 2012年 KAKEGAWA Atsushi. All rights reserved.
//

#import "CMDoubleTapAndPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static CGFloat const ScalePerPixel = 0.01f;

@interface CMDoubleTapAndPanGestureRecognizer () {
    __weak UITouch *trackingTouch;
}

@end

@implementation CMDoubleTapAndPanGestureRecognizer

- (void)reset
{
    trackingTouch = nil;
    _scale = 1.0f;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // ２つ以上のタッチがある場合とダブルタップ以外は処理しない
    if (event.allTouches.count != 1 || touch.tapCount != 2) {
        if (trackingTouch) {
            self.state = UIGestureRecognizerStateEnded;
        }
        return;
    }
    
    trackingTouch = touch;
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ジェスチャが開始されていない場合とジェスチャの開始を成立させたタッチが含まれない場合は処理をしない
    if (!trackingTouch || ![touches containsObject:trackingTouch]) {
        return;
    }
    
    CGPoint point = [trackingTouch locationInView:nil];
    CGPoint previousPoint = [trackingTouch previousLocationInView:nil];
    CGFloat delta = previousPoint.y - point.y;
    _scale = 1.0f + delta * ScalePerPixel;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ジェスチャが開始されていない場合とジェスチャの開始を成立させたタッチが含まれない場合は処理をしない
    if (!trackingTouch || ![touches containsObject:trackingTouch]) {
        return;
    }
    
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ジェスチャが開始されていない場合とジェスチャの開始を成立させたタッチが含まれない場合は処理をしない
    if (!trackingTouch || ![touches containsObject:trackingTouch]) {
        return;
    }
    
    self.state = UIGestureRecognizerStateCancelled;
}

@end
