//
//  ViewController.m
//  UIKit力学
//
//  Created by 霍文轩 on 16/1/29.
//  Copyright © 2016年 霍文轩. All rights reserved.
//

#import "ViewController.h"

/**
 *  盒子重力加速度下降
 *  盒子在碰到棍子后弹起翻转
 *  盒子碰到球吸附
 */
@interface ViewController () <UICollisionBehaviorDelegate>{
    BOOL _firstContact; // 记录方块是否是第一次碰撞
}
@property (weak, nonatomic) IBOutlet UIView *box; // 盒子
@property (weak, nonatomic) IBOutlet UIImageView *line; // 木棍
@property (weak, nonatomic) IBOutlet UIImageView *ball; // 球

@property (nonatomic, retain) UIDynamicAnimator * animator;
@property (nonatomic, retain) UIGravityBehavior * gravity; // 重力
@property (nonatomic, retain) UICollisionBehavior * collision; // 碰撞
@property (nonatomic, retain) UIAttachmentBehavior * attachment; // 吸附
@end

@implementation ViewController

- (void)viewDidLoad {
    _ball.layer.masksToBounds = YES;
    _ball.layer.cornerRadius = _ball.frame.size.width / 2;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 重力
     self.gravity = [[UIGravityBehavior alloc] initWithItems:@[_box]];
    // 设置重力的方向
//    CGVector gravityDirection = {0.0, 5}; // 如果y为负向上运动，值越大速度越大
//    _gravity.gravityDirection = gravityDirection;
    [_animator addBehavior:_gravity]; // 添加到animator中
    
    // 碰撞
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[_box]];
    _collision.translatesReferenceBoundsIntoBoundary = YES; // 检测发生碰撞
    [_animator addBehavior:_collision];
    // 检测是否与其他视图边界进行碰撞
    [_collision addBoundaryWithIdentifier:@"collision" fromPoint:_line.frame.origin toPoint:CGPointMake(_line.frame.origin.x + _line.frame.size.width, _line.frame.origin.y)];
    _collision.collisionDelegate = self; // 设置代理
    
    // 参数
    UIDynamicItemBehavior * item = [[UIDynamicItemBehavior alloc] initWithItems:@[_box]];
    item.elasticity = 0.5;
    [_animator addBehavior:item];
}

// 检测到碰撞后进行的处理
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    if ( !_firstContact ) {
        _firstContact = YES;
        
        // 吸附，小球吸附在盒子里
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:_ball attachedToItem:_box];
        [self.animator addBehavior:_attachment];
        
        // 推
        UIPushBehavior * push = [[UIPushBehavior alloc] initWithItems:@[_box] mode:UIPushBehaviorModeInstantaneous];
        CGVector pushDir = {0.5, -0.5};
        push.pushDirection = pushDir;
        push.magnitude = 5.0;
        [_animator addBehavior:push];
    }
}
@end
