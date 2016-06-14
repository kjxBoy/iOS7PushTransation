//
//  ViewController.m
//  测试
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "PushAnimation.h"

@interface ViewController ()<UINavigationControllerDelegate>

#pragma mark - 手势1.设置一个手势转场类
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

#pragma mark - 转场1.写一个动画
@property (nonatomic, strong)PushAnimation *pushAnimation;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    #pragma mark - 手势2.添加一个手势
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:popRecognizer];

     _pushAnimation = [PushAnimation new];
    
}

- (IBAction)pushEdit:(id)sender {
    
    SecondViewController *sec = [[SecondViewController alloc] init];
    
    [self.navigationController pushViewController:sec animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    #pragma mark - 转场2.设置一个代理
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
    
    self.title = @"测试";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}
#pragma mark UINavigationControllerDelegate methods

#pragma mark - 转场3.实现代理方法
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else{
        return nil;
    }
}

#pragma mark - 手势3.实现手势代理
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[PushAnimation class]]) {
        return self.interactivePopTransition;
    }
    else {
        return nil;
    }
}


#pragma mark UIGestureRecognizer handlers
#pragma mark - 手势4.实现手势
- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    
    
    CGFloat mx = [recognizer translationInView:self.view].x;
    
    CGFloat progress = ABS(mx)  / (self.view.bounds.size.width * 1.0);
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        SecondViewController *sec = [[SecondViewController alloc] init];
        
        [self.navigationController pushViewController:sec animated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}



@end
