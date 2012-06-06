//
//  HelloWorldLayer.m
//  BrickCollision
//
//  Created by SangChan Lee on 12. 6. 6..
//  Copyright gyaleon@paran.com 2012년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
        isPlaying = YES;
        targets = [[NSMutableArray alloc]init];
        BRICKS_WIDTH = 5;
        BRICKS_HEIGHT = 4;
        
        [self initBrick];
        [self initBall];
        [self initPaddle];
        [self performSelector:@selector(startGame) withObject:self afterDelay:2.0];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)startGame
{
    ball.position = ccp(160, 240);
    
    ballMovement = CGPointMake(4,4);
    if (arc4random() % 100 < 50)
        ballMovement.x = -ballMovement.x;
    
    isPlaying = YES;
    
    [self schedule:@selector(gameLogic:) interval:2/60 ];
    
}

-(void)initBrick {
    int count = 0;
    for (int y = 0; y < BRICKS_HEIGHT; y++) {
        for (int x = 0; x < BRICKS_WIDTH; x++) {
            CCSprite *bricks = [CCSprite node];
            [bricks setTextureRect:CGRectMake(0, 0, 64, 40)];
            
            switch (count++ %4) {
                case 0:
                    [bricks setColor:ccc3(255, 255, 255)];
                    break;
                case 1:
                     [bricks setColor:ccc3(255, 0, 0)];
                    break;
                case 2:
                    [bricks setColor:ccc3(255, 255, 0)];
                    break;
                case 3 :
                    [bricks setColor:ccc3(75, 255, 0)];
                    break;
                default:
                    break;
            }
        bricks.position = ccp(x*64+32,(y*40)+280);
        [self addChild:bricks];
        [targets addObject:bricks];
        }
    }
}
-(void)initBall {
    ball = [CCSprite node];
    [ball setTextureRect:CGRectMake(0, 0, 16, 16)];
    [ball setColor:ccc3(0, 255, 255)];
    ball.position = ccp(160,240);
    [self addChild:ball];
}
-(void)initPaddle {
    paddle = [CCSprite node];
    [paddle setTextureRect:CGRectMake(0, 0, 80, 10)];
    [paddle setColor:ccc3(255, 255, 0)];
    paddle.position = ccp(160,50);
    [self addChild:paddle];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isPlaying) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
    
    CGFloat halfWidth = paddle.contentSize.width / 2.0;
    CGFloat halfHeight = paddle.contentSize.height / 2.0;
    
    if (convertedLocation.x > (paddle.position.x + halfWidth) || convertedLocation.x < (paddle.position.x - halfWidth) || 
        convertedLocation.y > (paddle.position.y + halfHeight) || convertedLocation.y < (paddle.position.y - halfHeight))  {
        isPaddleTouched = NO;
    } else {
        isPaddleTouched = YES;
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isPaddleTouched) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if (convertedLocation.x < 40) {
            convertedLocation.x = 40;
        }
        if (convertedLocation.x > 280) {
            convertedLocation.x = 280;
        }
        
        CGPoint newLocation = ccp(convertedLocation.x,paddle.position.y);
        paddle.position = newLocation;
        
    }
}

-(void)gameLogic:(ccTime)dt {
    ball.position = ccp(ball.position.x+ballMovement.x, ball.position.y+ballMovement.y);
    BOOL paddleCollision = ball.position.y <= paddle.position.y+13 && ball.position.x >= paddle.position.x -48 && ball.position.x <= paddle.position.x+48;
    if (paddleCollision) {
        if (ball.position.y <= paddle.position.y + 13 && ballMovement.y < 0) {
            ball.position = ccp(ball.position.x, paddle.position.y+13);
        }
        ballMovement.y = -ballMovement.y;
    }
    
    BOOL thereAreSolidBrick = NO;
    for (CCSprite *brick in targets) {
        if (255 == brick.opacity) {
            thereAreSolidBrick = YES;
            if (CGRectIntersectsRect(ball.boundingBox, brick.boundingBox)) {
                [self processCollision:brick];
            }
        }
    }
    
    if (!thereAreSolidBrick) {
        isPlaying = NO;
        ball.opacity = 0;
        [self unscheduleAllSelectors];
        NSLog(@"you win!");
    }
    
    if (ball.position.x > 312 || ball.position.x  < 8) {
        ballMovement.x = -ballMovement.x;
    }
    if (ball.position.y > 450) {
        ballMovement.y = -ballMovement.y;
    }
    
    if (ball.position.y < (50+5+8)) {
        isPlaying = NO;
        ball.opacity = 0;
        [self unscheduleAllSelectors];
        NSLog(@"you dead");
    }
}

-(void) processCollision:(CCSprite *)brick {
    if (ballMovement.x > 0 && brick.position.x < ball.position.x) {
        ballMovement.x = -ballMovement.x;
    }
    else if (ballMovement.x < 0 && brick.position.x < ball.position.x) {
        ballMovement.x = -ballMovement.x;
    }
    
    if (ballMovement.y > 0 && brick.position.y > ball.position.y) {
        ballMovement.y = -ballMovement.y;
    }
    else if (ballMovement.y < 0 && brick.position.y < ball.position.y) {
        ballMovement.y = -ballMovement.y;
    }
    
    brick.opacity = 0;
}
@end
