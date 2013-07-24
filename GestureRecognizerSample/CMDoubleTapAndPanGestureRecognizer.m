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

@interface CMDoubleTapAndPanGestureRecognizer ()

@end

@implementation CMDoubleTapAndPanGestureRecognizer {
    NSTimer *_timeOutTimer;
}

- (void)reset {
    _scale = 1.0f;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self invalidateTimer];
    if ([touches count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    } else {
        UITouch *touch = [touches anyObject];
        if (touch.tapCount == 1) {
            _timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimeOut) userInfo:nil repeats:NO];
        } else if (touch.tapCount == 2) {
            return;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self invalidateTimer];
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        CGPoint point = [touch locationInView:nil];
        CGPoint previousPoint = [touch previousLocationInView:nil];
        CGFloat delta = previousPoint.y - point.y;
        _scale = 1.0f + delta * ScalePerPixel;
        
        if (self.state == UIGestureRecognizerStatePossible) {
            self.state = UIGestureRecognizerStateBegan;
        } else {
            self.state = UIGestureRecognizerStateChanged;
        }
    }
    else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self invalidateTimer];
    UITouch *touch = [touches anyObject];
    if (self.state == UIGestureRecognizerStatePossible &&
        touch.tapCount < 2) {
        _timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(handleTimeOut) userInfo:nil repeats:NO];
    }
    else {
        if (self.state == UIGestureRecognizerStateBegan ||
            self.state == UIGestureRecognizerStateChanged) {
            self.state = UIGestureRecognizerStateEnded;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self invalidateTimer];
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)invalidateTimer {
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
}

- (void)handleTimeOut {
    [self invalidateTimer];
    self.state = UIGestureRecognizerStateFailed;
}

@end
