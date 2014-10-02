//
//  ViewController.m
//  Breakout
//
//  Created by Asher Rosenblatt on 7/31/14.
//  Copyright (c) 2014 Asher Rosenblatt. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>
@property (strong, nonatomic) IBOutlet PaddleView *paddleView;
@property (strong, nonatomic) IBOutlet BallView *ballView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleDynamicItemBehavior;
@property UIDynamicItemBehavior *ballDynamicItemBehavior;
@property NSMutableArray *blocksArray;
@property int scoreOne;
@property int scoreTwo;
@property BOOL turn;
@property (weak, nonatomic) IBOutlet UILabel *playerOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	// Do any additional setup after loading the view, typically from a nib.

    [self resetAll];

}

- (void)resetAll
{
    NSLog(@"CALLED ONCE");
    self.turn = !self.turn;
    
    if (self.turn) {
        self.playerOneLabel.textColor = [UIColor purpleColor];
        self.playerTwoLabel.textColor = [UIColor blackColor];
    } else {
        self.playerTwoLabel.textColor = [UIColor purpleColor];
        self.playerOneLabel.textColor = [UIColor blackColor];
    }
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    int num = 1;
    if (((double)arc4random() / RAND_MAX) > 0.5) {
        num = -1;
    }
    self.pushBehavior.pushDirection = CGVectorMake(num * ((double)arc4random() / RAND_MAX), ((double)arc4random() / RAND_MAX)+0.3);
    self.pushBehavior.magnitude = 0.3;
    self.pushBehavior.active = YES;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView]];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    

    self.paddleDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleDynamicItemBehavior.allowsRotation = NO;
    self.paddleDynamicItemBehavior.density = 1000;
    [self.dynamicAnimator addBehavior:self.paddleDynamicItemBehavior];

    self.ballDynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballDynamicItemBehavior.allowsRotation = NO;
    self.ballDynamicItemBehavior.elasticity = 1.0;
    self.ballDynamicItemBehavior.density = 1;
    self.ballDynamicItemBehavior.friction = 0;
    self.ballDynamicItemBehavior.resistance = 0;
    [self.dynamicAnimator addBehavior:self.ballDynamicItemBehavior];
    [self makeTheBlocks];

}

- (void)makeTheBlocks
{
    for (BlockView *blockView in self.view.subviews) {
        if ([blockView isKindOfClass:[BlockView class]]) {
            blockView.frame = CGRectZero;
            [blockView removeFromSuperview];
            [self.dynamicAnimator updateItemUsingCurrentState:blockView];

        }
    }
    self.blocksArray = [[NSMutableArray alloc] init];

    for (int i= 0; i < 5; i++) {
        for (int t = 0; t < 3; t++) {
            BlockView *blockView = [[BlockView alloc] init];
            [self.blocksArray addObject:blockView];
            blockView.frame = CGRectMake(40 + i*50, 80 + t*50, 35, 35);
            [self.view addSubview:blockView];
            [self.collisionBehavior addItem:blockView];
            UIDynamicItemBehavior *dib = [[UIDynamicItemBehavior alloc] initWithItems:@[blockView]];
            [self.dynamicAnimator addBehavior:dib];
            dib.density = 1000;
            dib.allowsRotation = NO;
        }
    }


}

- (IBAction)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
        self.paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
        //[panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
    if (self.ballView.center.y == (self.paddleView.center.y - 30) ) {
        self.ballView.center = CGPointMake(self.paddleView.center.x, self.ballView.center.y);
        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
    }
    
    
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (p.y > self.view.bounds.size.height-5) {
        self.ballView.center = CGPointMake(self.paddleView.center.x, self.paddleView.center.y - 30);
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeContinuous];
        [self.dynamicAnimator addBehavior:self.pushBehavior];
        self.pushBehavior.active = NO;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if (![item1 isKindOfClass:[PaddleView class]] && ![item2 isKindOfClass:[PaddleView class]]) {
        if (self.turn) {
            self.scoreOne++;
            self.playerOneLabel.text = [NSString stringWithFormat:@"PlayerOne: %d", self.scoreOne];
        } else {
            self.scoreTwo++;
            self.playerTwoLabel.text = [NSString stringWithFormat:@"PlayerTwo: %d", self.scoreTwo];
        }
        
        BlockView *blockView =(BlockView*)(([item1 isKindOfClass:[BlockView class]])?item1:item2);

        [blockView disappearWithDynamicAnimator:self.dynamicAnimator collisionBehavior:self.collisionBehavior];
        [self.blocksArray removeObject:blockView];
        if ([self shouldStartAgain]) {
            [self resetAll];
        }
    }
}


- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    [self resetAll];
}


- (BOOL)shouldStartAgain
{
    return (self.blocksArray.count == 0);
}

@end
