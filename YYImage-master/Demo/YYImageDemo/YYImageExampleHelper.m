//
//  YYImageExampleUtils.m
//  YYKitExample
//
//  Created by ibireme on 15/7/20.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYImageExampleHelper.h"
#import "YYImage.h"
#import "UIView+YYAdd.h"
#import "UIGestureRecognizer+YYAdd.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
//#import <bpg/libbpg.h>

@implementation YYImageExampleHelper

+ (void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UILongPressGestureRecognizer *sender) {
//        if ([_view isAnimating]) [_view stopAnimating];
//        else  [_view startAnimating];
        
        // add a "bounce" animation
//        if (sender.state == UIGestureRecognizerStateBegan) {
        _view.transform = CGAffineTransformScale(_view.transform, 1.2, 1.2);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _view.transform = CGAffineTransformIdentity;
        });
//        }
    }];
    [view addGestureRecognizer:tap];
}

+ (void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    __block BOOL previousIsPlaying;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        UIImage<YYAnimatedImage> *image = (id)_view.image;
        if (![image conformsToProtocol:@protocol(YYAnimatedImage)]) return;
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        if (gesture.state == UIGestureRecognizerStateBegan) {
            previousIsPlaying = [_view isAnimating];
            [_view stopAnimating];
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        } else if (gesture.state == UIGestureRecognizerStateEnded ||
                   gesture.state == UIGestureRecognizerStateCancelled) {
            if (previousIsPlaying) [_view startAnimating];
        } else {
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
    }];
    [view addGestureRecognizer:pan];    
}

@end
