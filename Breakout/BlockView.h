//
//  BlockView.h
//  Breakout
//
//  Created by Asher Rosenblatt on 7/31/14.
//  Copyright (c) 2014 Asher Rosenblatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockView : UIView

- (void)disappearWithDynamicAnimator:(UIDynamicAnimator *)dynamicAnimator collisionBehavior:(UICollisionBehavior *)collisionBehavior;
@end
