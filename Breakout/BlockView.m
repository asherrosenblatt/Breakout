//
//  BlockView.m
//  Breakout
//
//  Created by Asher Rosenblatt on 7/31/14.
//  Copyright (c) 2014 Asher Rosenblatt. All rights reserved.
//

#import "BlockView.h"


@implementation BlockView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [self randomBlock];
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (UIColor *)randomBlock
{
    int random = arc4random()%4;
    
    UIColor *returnColor;
    switch (random) {
        case 0:
            returnColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boo"]];
            break;
        case 1:
            returnColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wario"]];
            break;
        case 2:
            returnColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bowser"]];
            break;
        case 3:
            returnColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"boo"]];
        default:
            returnColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brickblock"]];
            break;
    }
    return returnColor;
}

- (void)disappearWithDynamicAnimator:(UIDynamicAnimator *)dynamicAnimator collisionBehavior:(UICollisionBehavior *)collisionBehavior
{
    if ([self.backgroundColor isEqual:[UIColor brownColor]]) {
        self.backgroundColor = [UIColor yellowColor];
        return;
    }
    if ([self.backgroundColor isEqual:[UIColor yellowColor]]) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    
    self.backgroundColor = [UIColor redColor];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.frame = CGRectZero;
    } completion:^(BOOL finished) {
        [collisionBehavior removeItem:self];
        [dynamicAnimator updateItemUsingCurrentState:self];
        [self removeFromSuperview];
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
