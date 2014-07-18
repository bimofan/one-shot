//
//  SpriteMyScene.m
//  one shot
//
//  Created by mac on 13-11-4.
//  Copyright (c) 2013年 HaikunZhu. All rights reserved.
//

#define kblood
#import "Constants.h"

#import "GameScene01.h"
#import "dotbase.h"
#import <UIKit/UIKit.h>
#import  "define.h"
#import <GameKit/GameKit.h>
#import "SpriteViewController.h"
#import "GADBannerView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GameScene01()
{  CGSize winsize;
    NSUserDefaults *defaults;
    
    NSMutableArray *dotArray;
    NSMutableArray *rewardArray;
    NSMutableArray *protectDotArray;
    NSMutableArray *removeDotArray;
    
    CGFloat duration;
   
    SKTextureAtlas *toolsAtlas;
    SKTextureAtlas *AnimationAtlas;
    dotbase *dotbuttonsp1;
    dotbase *dotbuttonsp2;
    dotbase *dotbuttonsp3;
    dotbase *dotbuttonsp4;
    SKSpriteNode *TheTouchNode;
    
    
    NSInteger dotNum;
    
    SKLabelNode *scorelabel;
    
    NSInteger ScoreNum;
    
    
    SKLabelNode *lifeNumLabel;
    
    
    BOOL accelorateOne;
    BOOL accelorateTwo;
    
  
    
    //life and blood
    NSInteger  bloodNum;
    NSInteger lifeNum;
    
    SKSpriteNode *BloodSp1;
    CGPoint bloodSpPosition;
    CGPoint lifeNumLabelPosition;
    
    
    BOOL  Protected;
    CGPoint ProtectPosition;
    
    //about game over
    
  
    BOOL GameOvevred;
    
    SKLabelNode *gameoverlabel;


    
    
    
    //timer
    NSTimer *timer;
    
    UIView *GOUpView;
    UIButton *restartButton2;
    UIButton *gohomeButton;
    
    //continue game
    BOOL continued;
    NSInteger continueLifeNum;
    
    GKGameCenterViewController *gameCenterController;
    
    UIButton *showGameCenterButton;

  
    UIButton *restartButton;
    UIButton *gameStartButton;
    
    SKSpriteNode *gameStartNode;
    SKSpriteNode *showGameCenterNode;
  
    
    CGFloat Hue;
    CGFloat Sarution;
    
    SKLabelNode *TitleLabel;
    SKLabelNode *TitleLabel2;
    
    
    BOOL IsRemoveAllActing;
    
    
    //google admob
    
    GADBannerView *_bannerView;
    BOOL isRestarted;
    
    int  soundID;
    
    
}


@property (nonatomic) NSTimer *timer;

@property (nonatomic) CGFloat progress;

@property (nonatomic) NSArray *progressViewArray;
@property(nonatomic) UIScrollView *scrollView;
@property(nonatomic) UIPageControl *pageControll;
@end


@implementation GameScene01

@synthesize timer;

-(UIViewController*)getRootViewController
{
     return [UIApplication sharedApplication].keyWindow.rootViewController;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
   
        
        
        self.backgroundColor = [SKColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:100.0/255.0 alpha:1];
        winsize = self.size;
        defaults = [NSUserDefaults standardUserDefaults];
        
        dotArray = [[NSMutableArray alloc]init];
        rewardArray = [[NSMutableArray alloc]init];
        protectDotArray = [[NSMutableArray alloc]init];
        removeDotArray = [[NSMutableArray alloc]init];
      
       //set dot move duration time
      
        if (DeviceIsiPhone5)
        {
            duration = 4.5;
        }
        else
        {
            
           duration = 3.5;
            
        }
        
        //set blood number
        bloodNum = 5;
        
        
        //init atlas
      
        toolsAtlas = [SKTextureAtlas atlasNamed:@"demo@2x"];
        AnimationAtlas = [SKTextureAtlas atlasNamed:@"animation@2x"];
        
        SKTexture *gamestartTexture = [SKTexture textureWithImageNamed:@"play.png"];
        gameStartNode = [[SKSpriteNode alloc]initWithTexture:gamestartTexture];
        gameStartNode.position = CGPointMake(110, winsize.height/2);
        [self addChild:gameStartNode];
        gameStartNode.xScale = 0;
        gameStartNode.yScale = 0;
        
        SKTexture *gamecenterTexture = [SKTexture textureWithImageNamed:@"gamecenter.png"];
        showGameCenterNode = [[SKSpriteNode alloc]initWithTexture:gamecenterTexture];
        showGameCenterNode.position = CGPointMake(210, winsize.height/2);
        [self addChild:showGameCenterNode];
        showGameCenterNode.xScale = 0;
        showGameCenterNode.yScale = 0;
        
    

        SKAction *waite = [SKAction waitForDuration:0.7];
        
        SKAction *scale1 = [SKAction scaleTo:1.0 duration:0.5];
        SKAction *scale2 = [SKAction scaleTo:1.1 duration:0.1];
        SKAction *scale3 = [SKAction scaleTo:1.0 duration:0.1];
        SKAction *scale4 = [SKAction scaleTo:0.9 duration:0.1];
        SKAction *scale5 = [SKAction scaleTo:1.0 duration:0.1];
        SKAction *seq = [SKAction sequence:@[waite,scale1,scale2,scale3,scale4,scale5]];
        [gameStartNode runAction:seq];
        
        [showGameCenterNode runAction:seq];
        

        accelorateOne = NO;
        
        accelorateTwo = NO;
        
        GameOvevred = YES;
        
      
        [self addTitle];
      
        [self addmovesp];
        
        
        [self addlifeNumber];
     
        
     
        [self update:1/60];
        
        soundID = 1016;
       // AudioServicesPlaySystemSound();
    
    }
    return self;
}
-(void)GameStart
{
    
    //requst banner view
    _bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, winsize.height + 50, 320, 50)];
    _bannerView.adUnitID = publishID;
    UIViewController *RVC = [self getRootViewController];
    _bannerView.rootViewController = RVC;
    _bannerView.backgroundColor = [UIColor colorWithRed:40.0/255.5 green:40.0/255.0 blue:100.0/255.0 alpha:1];
    [_bannerView loadRequest:[GADRequest request]];
    
   
    
    SKAction *moveToLeftAction = [self removeLeftTitleLabelAction];
    [TitleLabel  runAction:moveToLeftAction];
    SKAction *moveToRightAction = [self removeRightTitlelabelAction];
    [TitleLabel2 runAction:moveToRightAction];
    
    [showGameCenterNode runAction:[self removeGameStartNodeAction] completion:^{
        
    }];
    
    
    SKAction *removegameStartNodeAction = [self removeGameStartNodeAction];
    [gameStartNode runAction:removegameStartNodeAction completion:^{
        
        [self addsocereLabel];
        [self addbloodSp];
        
    }];
 
    GameOvevred = NO;
    [self showreadygolabel];
    
   
    [self addbuttonSp];
    
}

#pragma mark - remove Title Label Action

-(SKAction*)removeGameStartNodeAction
{
    SKAction *scaleToZero = [ SKAction scaleTo:0 duration:0.6];
    SKAction *scaleSeq = [SKAction sequence:@[scaleToZero,[SKAction removeFromParent]]];
    return scaleSeq;
}
-(SKAction*)removeLeftTitleLabelAction
{
    SKAction *moveToLeft = [SKAction moveTo:CGPointMake(-140, TitleLabel.position.y) duration:0.6];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqLeft = [SKAction sequence:@[moveToLeft,removeAction]];
    
    return seqLeft;
    
}
-(SKAction*)removeRightTitlelabelAction
{
    SKAction *moveToRight = [SKAction moveTo:CGPointMake(winsize.width +140, TitleLabel2.position.y) duration:0.6];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqRight = [SKAction sequence:@[moveToRight,removeAction]];
    
    return seqRight;
}
#pragma mark - add title main buttons
-(SKAction*)addTitleActionWithX:(CGFloat)positionX  withY:(CGFloat)positionY
{
    SKAction *moveAction = [SKAction moveTo:CGPointMake(positionX, positionY) duration:1];
    SKAction *scale1 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:1.0 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale4 = [SKAction scaleTo:1.0 duration:0.1];
    
    SKAction *seq = [SKAction sequence:@[moveAction,scale1,scale2,scale3,scale4]];
    
    return seq;
}
-(void)addTitle
{
    TitleLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    TitleLabel.text = @"color";
    TitleLabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    TitleLabel.position = CGPointMake(-70, winsize.height-100);
    TitleLabel.fontSize = 50;
    [self addChild:TitleLabel];
    
    SKAction *titleLabel1Action = [self addTitleActionWithX:140 withY:winsize.height -100];
    [TitleLabel runAction:titleLabel1Action];
    
    
    
    TitleLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    TitleLabel2.text = @"show";
    TitleLabel2.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    TitleLabel2.position = CGPointMake(winsize.width + 90, winsize.height-150);
    TitleLabel2.fontSize = 50;
    [self addChild:TitleLabel2];
    
    SKAction *titleLabel2Action = [self addTitleActionWithX:180 withY:winsize.height -150];
    [TitleLabel2 runAction:titleLabel2Action];
    
}


#pragma mark - ready go
-(void)showreadygolabel
{
    
    AudioServicesPlaySystemSound(1304);
    
    SKAction * scaleAction = [self readygoAction];
    
    SKLabelNode *readyLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    readyLabel.text = @"ready!";
    readyLabel.fontSize = 50;
    readyLabel.position = CGPointMake(winsize.width/2, winsize.height/2+120);
    readyLabel.fontColor = [SKColor colorWithRed:248.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:1.0];
    readyLabel.zPosition = 12;
    readyLabel.xScale = 0;
    readyLabel.yScale = 0;
    
    [readyLabel runAction:scaleAction];
    [self addChild:readyLabel];
    
    SKLabelNode *goLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    goLabel.text = @"go!";
    goLabel.fontSize = 50;
    goLabel.fontColor = [SKColor colorWithRed:1 green:0 blue:0 alpha:1];
    goLabel.position = CGPointMake(winsize.width/2, winsize.height/2+120);
    goLabel.zPosition = 12;
    goLabel.xScale = 0;
    goLabel.yScale = 0;
    
    SKAction *sq = [SKAction sequence:@[[SKAction waitForDuration:0.5f],scaleAction]];
    [goLabel runAction:sq];
    [self addChild:goLabel];
}
-(SKAction*)readygoAction
{
    SKAction *scale = [SKAction scaleTo:1.1 duration:0.3];
    SKAction *scale2 = [SKAction scaleTo:0.95 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.1];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction* sq = [SKAction sequence:@[scale,scale2,scale3,remove]];
                    
    return sq;

}

#pragma mark - Blood

-(SKAction*)addbloodSpAndScoreLabelAction
{
    SKAction *scale1 = [SKAction scaleTo:1.1 duration:0.2];
    SKAction *scale2 = [SKAction scaleTo:0.9 duration:0.2];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.2];
    SKAction *seq = [SKAction sequence:@[scale1,scale2,scale3]];
    
    return seq;
    
}
-(void)addbloodSp
{
    
    bloodSpPosition = CGPointMake(winsize.width/2, winsize.height/2+40);
    
    SKTexture *t = [AnimationAtlas textureNamed:@"H_5.png"];
    
    BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
    BloodSp1.position = bloodSpPosition;
    BloodSp1.zPosition = 1;
    BloodSp1.xScale = 0;
    BloodSp1.yScale = 0;
    [self addChild:BloodSp1];
    
    SKAction *showAction = [self addbloodSpAndScoreLabelAction];
    [BloodSp1 runAction:showAction];
    
    
    
}

-(SKAction*)minusBloodAction
{
    SKAction *scale1 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.1];
    SKAction *sq = [SKAction sequence:@[scale1,scale2,scale3]];
    
    return sq;
}
-(void)removeBloodSp
{
    CGFloat PY = winsize.height/2 + 40;
    
    CGFloat PX = winsize.width /2;
    
    AudioServicesPlaySystemSound(1380);
    
    SKAction *minusAction = [self minusBloodAction];
    if (bloodNum == 4)
    {
        [BloodSp1 removeFromParent];
        
        SKTexture *t = [AnimationAtlas textureNamed:@"H_4.png"];
        BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
        BloodSp1.position =CGPointMake(PX, PY);
        BloodSp1.zPosition = 1;
        [BloodSp1 runAction:minusAction];
        [self addChild:BloodSp1];
        
    }
    
    else if (bloodNum == 3)
    {
        [BloodSp1 removeFromParent];
        
        SKTexture *t = [AnimationAtlas textureNamed:@"H_3.png"];
        BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
        BloodSp1.position =CGPointMake(PX, PY);
        BloodSp1.zPosition = 1;
        [self addChild:BloodSp1];
        [BloodSp1 runAction:minusAction];
    }
    
    else if (bloodNum == 2)
    {
        [BloodSp1 removeFromParent];
        
        SKTexture *t = [AnimationAtlas textureNamed:@"H_2.png"];
        BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
        BloodSp1.position =CGPointMake(PX, PY);
        BloodSp1.zPosition = 1;
        [self addChild:BloodSp1];
        [BloodSp1 runAction:minusAction];
    }
    
    else if (bloodNum == 1)
    {
        [BloodSp1 removeFromParent];
        
        SKTexture *t = [AnimationAtlas textureNamed:@"H_1.png"];
        BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
        BloodSp1.position =CGPointMake(PX, PY);
        BloodSp1.zPosition = 1;
        [self addChild:BloodSp1];
        [BloodSp1 runAction:minusAction];
        
    }
    
    else if (bloodNum == 0)
    {
        [BloodSp1 removeFromParent];
        
        SKTexture *t = [AnimationAtlas textureNamed:@"H_0.png"];
        BloodSp1 = [SKSpriteNode spriteNodeWithTexture:t];
        BloodSp1.position =CGPointMake(PX, PY);
        BloodSp1.zPosition = 1;
        [self addChild:BloodSp1];
        [BloodSp1 runAction:minusAction];
        
        [self GameOver];
        
        
    }
    
    
}

#pragma  mark - add score label
-(void)addsocereLabel
{
    scorelabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    scorelabel.fontSize = 20;
    scorelabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    scorelabel.position = CGPointMake(winsize.width/2, winsize.height/2 + 80);
    scorelabel.color = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    
    scorelabel.zPosition = 2;
    [self addChild:scorelabel];
    
    //init ScoreNum
    ScoreNum = 0;
    
    scorelabel.text = [NSString stringWithFormat:@"score:%ld",(long)ScoreNum];
   
    SKAction *showAction = [self addbloodSpAndScoreLabelAction];
    [scorelabel runAction:showAction];
    
 

    
}


#pragma mark -  touches

-(SKAction*)dotbuttonspAnimation
{
    SKAction *scale1 = [SKAction scaleTo:1.2 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale4 = [SKAction scaleTo:1.0 duration:0.1];
    SKAction *sq = [SKAction sequence:@[scale1,scale2,scale3,scale4]];
    
    return sq;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [self convertPointFromView:touchPoint];
    
    
    
    //show touchSp and animation
    SKAction *scaleAction = [self dotbuttonspAnimation];
    
    if (CGRectContainsPoint(dotbuttonsp1.frame, touchPoint))
    {
//        SKTexture *t = [AnimationAtlas textureNamed:@"D_B.png"];
//        TheTouchNode = [SKSpriteNode spriteNodeWithTexture:t];
//        TheTouchNode.position = dotbuttonsp1.position;
//        [self addChild:TheTouchNode];
//        
//        [TheTouchNode runAction:scaleAction];
        [dotbuttonsp1 runAction:scaleAction];
       
    }
    
    else if (CGRectContainsPoint(dotbuttonsp2.frame, touchPoint))
    {
//        SKTexture *t = [AnimationAtlas textureNamed:@"D_G.png"];
//        TheTouchNode = [SKSpriteNode spriteNodeWithTexture:t];
//        TheTouchNode.position = dotbuttonsp2.position;
//        [self addChild:TheTouchNode];
//        
//        [TheTouchNode runAction:scaleAction];
        [dotbuttonsp2 runAction:scaleAction];
    }
    else if (CGRectContainsPoint(dotbuttonsp3.frame, touchPoint))
    {
//        SKTexture *t = [AnimationAtlas textureNamed:@"D_Y.png"];
//        TheTouchNode = [SKSpriteNode spriteNodeWithTexture:t];
//        TheTouchNode.position = dotbuttonsp3.position;
//        [self addChild:TheTouchNode];
//        
//        [TheTouchNode runAction:scaleAction];
        [dotbuttonsp3 runAction:scaleAction];
    }
    else if (CGRectContainsPoint(dotbuttonsp4.frame, touchPoint))
    {
//        SKTexture *t = [AnimationAtlas textureNamed:@"D_R.png"];
//        TheTouchNode = [SKSpriteNode spriteNodeWithTexture:t];
//        TheTouchNode.position = dotbuttonsp4.position;
//        [self addChild:TheTouchNode];
//        
//        [TheTouchNode runAction:scaleAction];
        [dotbuttonsp4 runAction:scaleAction];
    }
    
    
    
    //check rewardDot Array
    
    BOOL touchRewardDot = NO;
    
    if (rewardArray.count >0 )
    {
        dotbase *rewardDot = [rewardArray objectAtIndex:0];
        if (dotArray.count >0)
        {
        dotbase *dot = [dotArray objectAtIndex:0];
        CGFloat rewardDotY = rewardDot.position.y;
        CGFloat dotY = dot.position.y;
        
        if (dotY >= rewardDotY)
        {
            
            
            if (CGRectContainsPoint(dotbuttonsp1.frame, touchPoint))
            {
                
                if (rewardDot.dotTag == dotbuttonTag1) {
                    [self removeRewardDotArray:rewardDot];
                    
                    touchRewardDot = YES;
                }
            }
            
            else if (CGRectContainsPoint(dotbuttonsp2.frame,touchPoint))
            {
                
                if (rewardDot.dotTag == dotbuttonTag2) {
                    [self removeRewardDotArray:rewardDot];
                      touchRewardDot = YES;
                }
                
            }
            
            else if (CGRectContainsPoint(dotbuttonsp3.frame, touchPoint))
            {
                
                
                if (rewardDot.dotTag == dotbuttonTag3) {
                    [self removeRewardDotArray:rewardDot];
                      touchRewardDot = YES;
                }
            }
            
            
            else if (CGRectContainsPoint(dotbuttonsp4.frame, touchPoint))
            {
                
                
                
                if (rewardDot.dotTag == dotbuttonTag4)
                {
                    [self removeRewardDotArray:rewardDot];
                      touchRewardDot = YES;
                }
            }
          }
        }
        else
        {
            
                
                if (CGRectContainsPoint(dotbuttonsp1.frame, touchPoint))
                {
                    
                    if (rewardDot.dotTag == dotbuttonTag1) {
                        [self removeRewardDotArray:rewardDot];
                        
                        touchRewardDot = YES;
                    }
                }
                
                else if (CGRectContainsPoint(dotbuttonsp2.frame,touchPoint))
                {
                    
                    if (rewardDot.dotTag == dotbuttonTag2) {
                        [self removeRewardDotArray:rewardDot];
                        touchRewardDot = YES;
                    }
                    
                }
                
                else if (CGRectContainsPoint(dotbuttonsp3.frame, touchPoint))
                {
                    
                    
                    if (rewardDot.dotTag == dotbuttonTag3) {
                        [self removeRewardDotArray:rewardDot];
                        touchRewardDot = YES;
                    }
                }
                
                
                else if (CGRectContainsPoint(dotbuttonsp4.frame, touchPoint))
                {
                    
                    
                    
                    if (rewardDot.dotTag == dotbuttonTag4)
                    {
                        [self removeRewardDotArray:rewardDot];
                        touchRewardDot = YES;
                    }
                }
            
         }
    }
    
    
    
    //check dot
    
    if (dotArray.count>0)
    {
        
    
    dotbase *dot = [dotArray objectAtIndex:0];
    
    
    if (CGRectContainsPoint(dotbuttonsp1.frame, touchPoint))
    {
      
        if (dot.dotTag == dotbuttonTag1 && touchRewardDot == NO)
        {
            [self removedotArraydot:dot ];
        }
        else if (touchRewardDot == NO)
        {
            
                bloodNum -=1;
                [self removeBloodSp];
            
          
        }

      
    }
    
   else if (CGRectContainsPoint(dotbuttonsp2.frame,touchPoint))
   {
       if (dot.dotTag == dotbuttonTag2 && touchRewardDot == NO)
       {
           [self removedotArraydot:dot ];
       }
       
       else if (touchRewardDot == NO)
       {
           
           bloodNum -=1;
           [self removeBloodSp];
       }
       
    
    
   }
    
    else if (CGRectContainsPoint(dotbuttonsp3.frame, touchPoint))
    {
        if (dot.dotTag == dotbuttonTag3 && touchRewardDot == NO)
        {
            [self removedotArraydot:dot ];
        }
    
       else if (touchRewardDot == NO)
        {
            bloodNum -=1;
            [self removeBloodSp];
        }
      
    }
    
    
    else if (CGRectContainsPoint(dotbuttonsp4.frame, touchPoint))
    {
       
        
        if (dot.dotTag == dotbuttonTag4 && touchRewardDot == NO)
        {
            [self removedotArraydot:dot ];
        }
      
       else if (touchRewardDot == NO)
        {
            bloodNum -=1;
            [self removeBloodSp];
        }
        
        
    }
    
    }
    
    
  


}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (GameOvevred)
//    {
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint touchpoint = [touch locationInView:[touch view]];
//    CGPoint previsePoint = [touch previousLocationInView:[touch view]];
//    
//    CGFloat touchY = touchpoint.y;
//    CGFloat pretouchY = previsePoint.y;
//    
//    CGFloat touchX = touchpoint.x;
//    CGFloat pretouchX = previsePoint.y;
//    
//    if (pretouchY > touchY)
//    {
//        [self setHue:YES];
//    }
//     else
//     {
//         [self setHue:NO];
//     }
//        
//        if (pretouchX > touchX)
//        {
//            [self setsaturation:YES];
//        }
//        else
//        {
//            [self setsaturation:NO];
//        }
//    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [self convertPointFromView:touchPoint];
    
    if (CGRectContainsPoint(gameStartNode.frame, touchPoint))
    {
        [self GameStart];
    }
    
    if (CGRectContainsPoint(showGameCenterNode.frame, touchPoint))
    {
        [self showgamedata];
    }
    if (TheTouchNode)
    {
        [TheTouchNode removeFromParent];
    }
    
    
}

#pragma mark - 4 buttons
-(SKAction*)addButtonAction:(CGFloat)buttonX
{
    SKAction *moveAction = [SKAction moveTo:CGPointMake(buttonX, 40) duration:0.5];
    SKAction *scale1 = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.1];
    SKAction *seq = [SKAction sequence:@[moveAction,scale1,scale2,scale3]];
    
    return seq;
}

-(void)showbuttonActions
{
   
    
}
-(void)addbuttonSp
{
  
   
 
       
        SKTexture *dot1 = [toolsAtlas textureNamed:@"blue.png"];
        dotbuttonsp1 = [dotbase spriteNodeWithTexture:dot1];
        dotbuttonsp1.position = CGPointMake(40, -30);
        dotbuttonsp1.tag = 1;
        dotbuttonsp1.zPosition = 11;
        [self addChild:dotbuttonsp1];
        
        SKAction *dot1Action = [self addButtonAction:dotbuttonsp1.position.x];
        [dotbuttonsp1 runAction:dot1Action];
        
        
        SKTexture *dot2 = [toolsAtlas textureNamed:@"red.png"];
        dotbuttonsp2 = [dotbase spriteNodeWithTexture:dot2];
        dotbuttonsp2.position = CGPointMake(120, -30);
        dotbuttonsp2.tag = 2;
        dotbuttonsp2.zPosition = 11;
        [self addChild:dotbuttonsp2];
        
        SKAction *dot2Action = [self addButtonAction:dotbuttonsp2.position.x];
        [dotbuttonsp2 runAction:dot2Action];
        
        SKTexture *dot3 = [toolsAtlas textureNamed:@"green.png"];
        dotbuttonsp3 = [dotbase spriteNodeWithTexture:dot3];
        dotbuttonsp3.position = CGPointMake(200, -30);
        dotbuttonsp3.tag =3;
        dotbuttonsp3.zPosition = 11;
        [self addChild:dotbuttonsp3];
        
        SKAction *dot3Action = [self addButtonAction:dotbuttonsp3.position.x];
        [dotbuttonsp3 runAction:dot3Action];
        
        SKTexture *dot4 = [toolsAtlas textureNamed:@"yellow.png"];
        dotbuttonsp4 = [dotbase spriteNodeWithTexture:dot4];
        dotbuttonsp4.position = CGPointMake(280, -30);
        dotbuttonsp4.tag = 4;
        dotbuttonsp4.zPosition = 11;
        [self addChild:dotbuttonsp4];
        
        SKAction *dot4Action = [self addButtonAction:dotbuttonsp4.position.x];
        [dotbuttonsp4 runAction:dot4Action];
    

   
}

//hide 4 shooter action
-(SKAction*)hidefourshooter:(CGFloat)pointX
{
    SKAction *moveback = [SKAction moveTo:CGPointMake(pointX, -50) duration:0.5];
    
    return moveback;
    
}


#pragma mark - gameoverLabel Action
-(SKAction*)gameoverLabelAction
{
    SKAction *moveto = [SKAction moveTo:CGPointMake(160, winsize.height - 100) duration:1.0];
    
    SKAction *move1 = [SKAction moveToY:winsize.height - 80 duration:0.4];
    SKAction *move2 = [SKAction moveToY:winsize.height - 100 duration:0.4];
    SKAction *move3 = [SKAction moveToY:winsize.height - 90 duration:0.2];
    SKAction *move4 = [SKAction moveToY:winsize.height - 100 duration:0.2];
    SKAction *move5 = [SKAction moveToY:winsize.height - 95 duration:0.1];
    SKAction *move6 = [SKAction moveToY:winsize.height -100 duration:0.1];
    SKAction *moveSeq = [SKAction sequence:@[move1,move2,move3,move4,move5,move6]];
    
    SKAction *scalex1 = [SKAction scaleYTo:0.9 duration:0.4];
    SKAction *scalex2 = [SKAction scaleYTo:1.1 duration:0.4];
    SKAction *scalex3 = [SKAction scaleYTo:0.9 duration:0.2];
    SKAction *scalex4 = [SKAction scaleYTo:1.1 duration:0.2];
    SKAction *scalex5 = [SKAction scaleYTo:0.9 duration:0.1];
    SKAction *scalex6 = [SKAction scaleXTo:1.0 duration:0.1];
    
    SKAction *seq = [SKAction sequence:@[scalex1,scalex2,scalex3,scalex4,scalex5,scalex6]];
    
    SKAction *group = [SKAction group:@[moveSeq,seq]];
    
    SKAction *finalSeqAction = [SKAction sequence:@[moveto,group]];
    
    return finalSeqAction;
    
}

#pragma mark - gameover staff
-(void)GameOver
{
   // self.speed = 0;
    
    AudioServicesPlayAlertSound(1024);
    GameOvevred = YES;

    //summit score
    [self reportScore:ScoreNum forCategory:HighScores];
    
    //impress score
    scorelabel.fontColor = [UIColor whiteColor];
    [scorelabel runAction:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.2],[SKAction scaleTo:0.9 duration:0.2],[SKAction scaleTo:1.0 duration:0.2]]]];
    
    //hide four dotbutton
    
    [dotbuttonsp1 runAction:[self hidefourshooter:dotbuttonsp1.position.x]];
    [dotbuttonsp2 runAction:[self hidefourshooter:dotbuttonsp2.position.x]];
    [dotbuttonsp3 runAction:[self hidefourshooter:dotbuttonsp3.position.x]];
    [dotbuttonsp4 runAction:[self hidefourshooter:dotbuttonsp4.position.x] completion:^{
       
        [self.view addSubview:_bannerView];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
        [_bannerView setFrame:CGRectMake(0, winsize.height - 50, 320, 50)];
            
            
            
        }];
    }];
    

    
    //remove bloodsp
    SKAction *bloodSpFadeOutAction = [SKAction fadeOutWithDuration:1.0];
    [BloodSp1 runAction:[SKAction sequence:@[bloodSpFadeOutAction,[SKAction removeFromParent]]]];
    
    
    gameoverlabel = [[SKLabelNode alloc]initWithFontNamed:@"Copperplate"];
    gameoverlabel.text = @"game over!";
    gameoverlabel.fontColor = [UIColor whiteColor];
    gameoverlabel.fontSize = 50;
    gameoverlabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    gameoverlabel.position = CGPointMake(160, winsize.height + 30);
    SKAction *gameoverlabelAction = [self gameoverLabelAction];
    [gameoverlabel runAction:gameoverlabelAction];
    [self addChild:gameoverlabel];
    
    restartButton = [[UIButton alloc]initWithFrame:CGRectMake(90, winsize.height/2, 50, 50)];
    [restartButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [restartButton addTarget:self action:@selector(restart2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restartButton];
    
    showGameCenterButton = [[UIButton alloc]initWithFrame:CGRectMake(200, winsize.height/2, 50, 50)];
    [showGameCenterButton setImage:[UIImage imageNamed:@"gamecenter.png"] forState:UIControlStateNormal];
    [showGameCenterButton addTarget:self action:@selector(showgamedata) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showGameCenterButton];
    

    
    
}

-(void)showgamedata
{
    
    [self presentGKGameCenterViewController];

    
}

-(void)presentGKGameCenterViewController
{
     gameCenterController = [[GKGameCenterViewController alloc]init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        [self presentViewController:gameCenterController];
    }
}

#pragma mark - GKGameCenterControllerDelegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterController dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark - getRootViewController


-(void)presentViewController:(UIViewController*)vc
{
    
    UIViewController*rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}


#pragma  mark - show four shooter
-(SKAction*)showfourshooter:(CGFloat)pointX
{
    SKAction *moveback = [SKAction moveTo:CGPointMake(pointX, -50) duration:0.5];
    
    return moveback;
    
}

#pragma mark - restart

-(void)restart2
{
    //minus lifeNum
    
    [gameoverlabel runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(winsize.width/2, winsize.height + 20) duration:0.5],[SKAction removeFromParent]]]];
    
    [restartButton removeFromSuperview];
    [showGameCenterButton removeFromSuperview];
    
    scorelabel.fontColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    ScoreNum = 0;
    
    scorelabel.text =[NSString stringWithFormat:@"score:%ld",(long)ScoreNum];
  
    //set dot move duration time
    
    if (DeviceIsiPhone5)
    {
        duration = 4.5;
    }
    else
    {
        
        duration = 3.5;
        
    }
    
    [self showreadygolabel];
    bloodNum = 5;
    [self addbloodSp];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [_bannerView setFrame:CGRectMake(0, winsize.height + 50, 320, 50)];
        
    } completion:^(BOOL finished)
     {
         if (finished)
         {
             [dotbuttonsp1 runAction:[self addButtonAction:dotbuttonsp1.position.x]];
             [dotbuttonsp2 runAction:[self addButtonAction:dotbuttonsp2.position.x]];
             [dotbuttonsp3 runAction:[self addButtonAction:dotbuttonsp3.position.x]];
             [dotbuttonsp4 runAction:[self addButtonAction:dotbuttonsp4.position.x]];
             
         }
     }];
    
    
    GameOvevred =NO;
}





#pragma mark - submit Score

-(void)reportScore:(int64_t)score forCategory:(NSString*)category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        
    }];
    
}

#pragma mark - show life number

-(void)addlifeNumber
{
    lifeNum = [defaults integerForKey:@"lifeNum"];
    
    lifeNumLabelPosition = CGPointMake(winsize.width +75, winsize.height - 27);
    
    lifeNumLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    lifeNumLabel.position = lifeNumLabelPosition;
    lifeNumLabel.fontColor = [SKColor redColor];
    lifeNumLabel.fontSize = 25;
    lifeNumLabel.text = [NSString stringWithFormat:@" X %ld",(long)lifeNum];
    lifeNumLabel.zPosition = 11;
    lifeNumLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [self addChild:lifeNumLabel];
    
    
}




#pragma mark  move Sp
-(void)addmovesp
{
   
    int i = rand()%4;
    int d = rand()%4;
    int rewardNum = rand()%40;
    BOOL rewardDotComed = NO;
    
    CGFloat rePositionX;
    CGFloat positionX;
    {switch (d)
    {
        case 0:
        {
            positionX = 40;
            
            rePositionX = 120;
        }
            break;
            case 1:
        {
            positionX = 120;
            rePositionX = 40;
        }
            break;
            case 2:
        {
            positionX = 200;
            rePositionX = 280;
            
        }
            break;
            case 3:
        {
            positionX = 280;
            rePositionX = 200;
            
        }
            break;
     
    }
    }

    
    
    
    //add remove all tool
    
    if (rewardNum == 4)
    {
         rewardDotComed = YES;
        SKTexture *dot1;
        NSInteger dottag;
        
        switch (i)
        {
            case 0:
            {
                dot1= [toolsAtlas textureNamed:@"xiaoshi_2.png"];
                dottag = dotbuttonTag3;
            }
                break;
                
            case 1:
            {
                dot1 = [toolsAtlas textureNamed:@"xiaoshi_4.png"];
                dottag = dotbuttonTag1;
                
            }
                break;
                
            case 2:
            {
                dot1 = [toolsAtlas textureNamed:@"xiaoshi_1.png"];
                dottag = dotbuttonTag2;
                
            }
                break;
                
            case 3:
            {
                dot1 = [toolsAtlas textureNamed:@"xiaoshi_3.png"];
                
                dottag = dotbuttonTag4;
            }
                break;
                
        }
        
        dotbase *movedot1 = [dotbase spriteNodeWithTexture:dot1];
        movedot1.appeared = NO;
        movedot1.RemoveAll = YES;
        movedot1.dotTag = dottag;
        movedot1.position = CGPointMake(rePositionX, winsize.height+130);
        SKAction *moveAction = [SKAction moveTo:CGPointMake(rePositionX, 40) duration:duration];
        
        SKAction *sequence = [SKAction sequence:@[moveAction]];
        
        [movedot1 runAction:sequence completion:^{
            
            [self MissRewardDotRemove:movedot1];
        }];
        
        movedot1.zPosition = 10;
        [rewardArray addObject:movedot1];
        [self addChild:movedot1 ];
        
    }

    
    //add move normal dots
    if (rewardDotComed == NO)
    {
        
    switch (i) {
        case 0:
        {
            
            SKTexture *dot1 = [toolsAtlas textureNamed:@"blue.png"];
            dotbase *movedot1 = [dotbase spriteNodeWithTexture:dot1];
            movedot1.appeared = NO;
            movedot1.freezed = NO;
            movedot1.dotTag = dotbuttonTag1;
            movedot1.position = CGPointMake(positionX, winsize.height+130);
            SKAction *moveAction = [SKAction moveTo:CGPointMake(positionX, 40) duration:duration];
           
            SKAction *sequence = [SKAction sequence:@[moveAction]];
           
            [movedot1 runAction:sequence completion:^{
               
                [self MissDotRemove:movedot1];
            }];
          
            movedot1.zPosition = 10;
            [dotArray addObject:movedot1];
            [self addChild:movedot1 ];
        }
            break;
            case 1:
        {
            
            SKTexture *dot2 = [toolsAtlas textureNamed:@"red.png"];
            dotbase *movedot2 = [dotbase spriteNodeWithTexture:dot2];
            movedot2.appeared = NO;
            movedot2.freezed = NO;
            movedot2.dotTag = dotbuttonTag2;
            movedot2.position = CGPointMake(positionX, winsize.height+130);
            SKAction *moveAction = [SKAction moveTo:CGPointMake(positionX, 40) duration:duration];
          
            SKAction *sequence = [SKAction sequence:@[moveAction]];
        
            [movedot2 runAction:sequence completion:^{
               
                [self MissDotRemove:movedot2];
            }];
          
            movedot2.zPosition = 10;
            [dotArray addObject:movedot2];
            [self addChild:movedot2 ];
        }
            break;
            case 2:
        {
            SKTexture *dot3 = [toolsAtlas textureNamed:@"green.png"];
            dotbase *movedot3 = [dotbase spriteNodeWithTexture:dot3];
            movedot3.appeared = NO;
            movedot3.freezed = NO;
            movedot3.dotTag = dotbuttonTag3;
            movedot3.position = CGPointMake(positionX, winsize.height+130);
            SKAction *moveAction = [SKAction moveTo:CGPointMake(positionX, 40) duration:duration];
         
            SKAction *sequence = [SKAction sequence:@[moveAction]];
           
            [movedot3 runAction:sequence completion:^{
               
                [self MissDotRemove:movedot3];
            }];
              
       
            movedot3.zPosition = 10;
            [dotArray addObject:movedot3];
            [self addChild:movedot3 ];
        }
            break;
            
            case 3:
        {
            SKTexture *dot4 = [toolsAtlas textureNamed:@"yellow.png"];
            dotbase *movedot4 = [dotbase spriteNodeWithTexture:dot4];
            movedot4.appeared = NO;
            movedot4.freezed = NO;
            movedot4.dotTag = dotbuttonTag4;
            movedot4.position = CGPointMake(positionX, winsize.height+130);
            SKAction *moveAction = [SKAction moveTo:CGPointMake(positionX, 40) duration:duration];
            
            SKAction *sequence = [SKAction sequence:@[moveAction]];
            
            [movedot4 runAction:sequence completion:^{
                
                [self MissDotRemove:movedot4];
            }];
               
         
            movedot4.zPosition = 10;
            [dotArray addObject:movedot4];
            [self addChild:movedot4 ];
        }
            break;
     
    }
    }
   
    
}

#pragma mark - reward dot effect

-(void)runRemoveAllEffect:(NSInteger)dotType position:(CGPoint)position
{
   
    SKSpriteNode *removeSp;
    switch (dotType) {
        case dotbuttonTag1:
        {
            SKTexture *t1 = [AnimationAtlas textureNamed:@"xiaochu_b.png"];
            removeSp = [SKSpriteNode spriteNodeWithTexture:t1];
            
        }
            break;
        case dotbuttonTag2:
        {
            SKTexture *t1 = [AnimationAtlas textureNamed:@"xiaochu_r.png"];
            removeSp = [SKSpriteNode spriteNodeWithTexture:t1];
            
        }
            break;
            
        case dotbuttonTag3:
        {
            SKTexture *t1 = [AnimationAtlas textureNamed:@"xiaochu_g.png"];
            removeSp = [SKSpriteNode spriteNodeWithTexture:t1];
            
        }
            break;
            
        case dotbuttonTag4:
        {
            SKTexture *t1 = [AnimationAtlas textureNamed:@"xiaochu_y.png"];
            removeSp = [SKSpriteNode spriteNodeWithTexture:t1];
            
        }
            break;
    }
    
    removeSp.position = position;
    
    removeSp.xScale = 0;
    removeSp.yScale = 0;
    
    [removeDotArray addObject:removeSp];
    [self addChild:removeSp];
    
    SKAction *expending = [self removeSpExpendingAction];
    
    IsRemoveAllActing = YES;
    
    [removeSp runAction:expending completion:^{
        
        [removeDotArray removeObject:removeSp];
        [removeSp removeFromParent];
        
        IsRemoveAllActing = NO;
        
    }];

    
 
}
-(SKAction*)removeSpExpendingAction
{
   
    
    SKAction *expendint = [SKAction scaleTo:2 duration:1];
    SKAction *fadeout = [SKAction fadeOutWithDuration:1];
    
    SKAction *group = [SKAction group:@[expendint,fadeout]];
    
    return group;
}

-(SKAction*)plusBloodSpAction
{

    CGFloat SpX = bloodSpPosition.x - 75;
    CGFloat SpY = bloodSpPosition.y;
  
    SKAction *move1 = [SKAction moveTo:CGPointMake(SpX, SpY) duration:0.3];
    SKAction *scale1  = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.1];
    
    SKAction *sq1 = [SKAction sequence:@[scale1,scale2,scale3,scale2]];
    
    SKAction *move2 = [SKAction moveTo:bloodSpPosition duration:0.3];
    
    SKAction *sq = [SKAction sequence:@[move1,scale1,scale2,scale3,sq1,move2,scale1,scale2,scale3]];
    
    return sq;
    
    
}

-(SKAction*)plusLableAction
{
    CGFloat LbpX = lifeNumLabelPosition.x - 75;
    CGFloat LbpY = lifeNumLabelPosition.y;
    
    SKAction *move1 = [SKAction moveTo:CGPointMake(LbpX, LbpY) duration:0.3];
    SKAction *scale1  = [SKAction scaleTo:0.9 duration:0.1];
    SKAction *scale2 = [SKAction scaleTo:1.1 duration:0.1];
    SKAction *scale3 = [SKAction scaleTo:1 duration:0.1];
    
    SKAction *sq = [SKAction sequence:@[move1,scale1,scale2,scale3]];
    
    return sq;
}
        
-(void)plusBloodSp
{
      //bloodsp move action
    SKAction *bloodSpAction = [self plusBloodSpAction];
    
    [BloodSp1 runAction:bloodSpAction];
    
    //life label move action
    SKAction *labelaction1 = [self plusLableAction];
    [lifeNumLabel runAction:labelaction1 completion:^{
        
        lifeNumLabel.text = [NSString stringWithFormat:@" X %ld",(long)lifeNum];
        
        SKAction *scale1 = [SKAction scaleTo:1.2 duration:0.2];
        SKAction *scale2 = [SKAction scaleTo:1 duration:0.2];
        SKAction *moveback = [SKAction moveTo:lifeNumLabelPosition duration:0.3];
        SKAction *sq = [SKAction sequence:@[scale1,scale2,moveback]];
        
        [lifeNumLabel runAction:sq];
    }];
    
  
}





#pragma mark - removedotArray
-(void)removeRewardDotArray:(id)sender
{
    dotbase *dot = (dotbase *)sender;
    
 
    if (dot.RemoveAll == YES)
    {
        [self runRemoveAllEffect:dot.dotTag position:dot.position];
    }
    
    
    [rewardArray removeObject:dot];
    [dot removeFromParent];
}



-(void)MissRewardDotRemove:(id)sender
{
    dotbase* redot = (dotbase*)sender;
    [rewardArray removeObject:redot];
    [redot removeFromParent];
}
-(void)MissDotRemove:(id)sender
{
    dotbase * dot = (dotbase*)sender;
    [dotArray removeObject:dot];
    [dot removeFromParent];
    
    bloodNum -=1;
    [self removeBloodSp];
}
-(void)removedotArraydot:(id)sender
{
    
    if (DeviceIsiPhone5)
    {
        if (duration >4 )
        {
            duration -=0.002;
        }
        if (duration < 4 ||duration == 4)
        {
            duration -= 0.001;
        }
    }
    else
    {
    if (duration > 3 && duration<= 4)
    {
        duration -=0.002;
    }
        else
        {
            duration -=0.001;
        }
    }

    
    AudioServicesPlaySystemSound(soundID);
   // soundID +=1;
//    if (soundID > 1213) {
//        soundID = 1201;
//    }
    
    NSLog(@"soundID : %ld",(long)soundID);
    
    
  //  NSLog(@"duration : %f",duration);
    
    
    ScoreNum +=1;
    scorelabel.text =[NSString stringWithFormat:@"score:%ld",(long)ScoreNum];
    
    
    dotbase *dot = (dotbase*)sender;
    
    [dot removeAllActions];
    
    [dotArray removeObject:dot];
    
    SKSpriteNode *ringSp = [[SKSpriteNode alloc]init];

    
    if (dot.dotTag == dotbuttonTag1)
    {
        SKTexture *t = [AnimationAtlas textureNamed:@"B.png"];
        ringSp = [SKSpriteNode spriteNodeWithTexture:t];
    }
   
    else if(dot.dotTag == dotbuttonTag2)
    {
        SKTexture *t = [AnimationAtlas textureNamed:@"R.png"];
        ringSp = [SKSpriteNode spriteNodeWithTexture:t];
    }
    
    else if (dot.dotTag == dotbuttonTag3)
    {
        SKTexture *t = [AnimationAtlas textureNamed:@"G.png"];
        ringSp = [SKSpriteNode spriteNodeWithTexture:t];
    }
    else if (dot.dotTag == dotbuttonTag4)
    {
        SKTexture *t = [AnimationAtlas textureNamed:@"Y.png"];
        ringSp = [SKSpriteNode spriteNodeWithTexture:t];
    }
    
    ringSp.position = dot.position;
    
    [self addChild:ringSp];
    SKAction *ringaction = [self ringAction];

    [ringSp runAction:ringaction completion:^{[ringSp removeFromParent];}];
    
    
//    SKAction *scale1 = [SKAction scaleTo:0.5 duration:0.5];
//    SKAction *scale2 = [SKAction scaleTo:0.6 duration:0.5];
      SKAction *scale3 = [SKAction scaleTo:0 duration:0.2];
//  
//    SKAction *sq = [SKAction sequence:@[scale1,scale2,scale3]];
    
    [dot runAction:scale3 completion:^{
        [dot removeFromParent];
        
    }];

  
    
    
}

-(SKAction*)ringAction
{
    SKAction *scale1 = [SKAction scaleTo:2.0 duration:0.4];
    SKAction *fade = [SKAction fadeOutWithDuration:0.4];
    SKAction *group = [SKAction group:@[scale1,fade]];
    
    return group;
}


-(void)update:(CFTimeInterval)currentTime
{
    
    if (GameOvevred == NO)
    {
        
    if (rewardArray.count >0)
    {
        for (NSInteger i = 0; i<rewardArray.count; i++)
        {
            dotbase *rewarddot = [rewardArray objectAtIndex:i];
            CGFloat f = rewarddot.position.y;
            if (f < winsize.height +50 && rewarddot.appeared == NO)
            {
                rewarddot.appeared = YES;
                
                [self addmovesp];
            }
        }
    }
    
    if (dotArray.count > 0)
    {
        
    for (NSInteger i =0;i<dotArray.count;i++)
    {
        dotbase*dot  = [dotArray objectAtIndex:i];
        
        CGFloat f = dot.position.y;
       
      
        if (f < winsize.height+50 && dot.appeared == NO)
        {
            dot.appeared = YES;
         
            [self addmovesp];
        }
        
        if (protectDotArray.count >0)
        {
            for (int i=0;i<protectDotArray.count; i++)
            {
                SKSpriteNode *protectdotSp = [protectDotArray objectAtIndex:i];
                if (CGRectIntersectsRect(dot.frame, protectdotSp.frame))
                {
                    [self removedotArraydot:dot];
                }
            }
            
        }
        
        if (removeDotArray.count >0)
        {
            for (int i = 0; i<removeDotArray.count; i++)
            {
                SKSpriteNode *removeSp = [removeDotArray objectAtIndex:i];
                if (CGRectIntersectsRect(removeSp.frame, dot.frame))
                {
                    [self removedotArraydot:dot];
                }
            }
        }
        
    }
     }
     }
    else
    {
        if (dotArray.count >0)
        {
            

        for (int i= 0; i<dotArray.count; i++)
        {
            dotbase *removedot = [dotArray objectAtIndex:i];
            [self removedotArraydot:removedot];
        }
        }
        
        if (rewardArray.count>0)
        {
            for (int i= 0; i<rewardArray.count; i++)
            {
                dotbase *toremoveRewardDot = [rewardArray objectAtIndex:i];
                [self removeRewardDotArray:toremoveRewardDot];
                
            }
        }
    }
    
    
    if (GameOvevred == NO)
    {
        if (!IsRemoveAllActing)
        {
            if (dotArray.count == 0 && rewardArray.count == 0)
            {
                [self addmovesp];
            }
        }
       
    }
   
    
    
}

@end
