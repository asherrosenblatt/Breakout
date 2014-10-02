//
//  PaddleView.m
//  Breakout
//
//  Created by Asher Rosenblatt on 7/31/14.
//  Copyright (c) 2014 Asher Rosenblatt. All rights reserved.
//

#import "PaddleView.h"

@implementation PaddleView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paddle"]];
    }
    return self;
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
