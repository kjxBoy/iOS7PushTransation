//
//  PushAnimation.m
//  测试
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "PushAnimation.h"

@implementation PushAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
         toVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
//         [transitionContext completeTransition:YES];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
         
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


@end
