//
//  CMViewController.h
//  GestureRecognizerSample
//
//  Created by KAKEGAWA Atsushi on 2012/12/16.
//  Copyright (c) 2012年 KAKEGAWA Atsushi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
