//
//  HelloWorldLayer.h
//  BrickCollision
//
//  Created by SangChan Lee on 12. 6. 6..
//  Copyright gyaleon@paran.com 2012년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite *ball;
    CCSprite *paddle;
    NSMutableArray *targets;
    
    int BRICKS_HEIGHT;
    int BRICKS_WIDTH;
    
    BOOL isPlaying;
    BOOL isPaddleTouched;
    
    CGPoint ballMovement;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)initBrick;
-(void)initBall;
-(void)initPaddle;
-(void)startGame;
-(void)processCollision:(CCSprite*)brick;

@end
