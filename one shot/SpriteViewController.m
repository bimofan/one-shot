//
//  SpriteViewController.m
//  one shot
//
//  Created by mac on 13-11-4.
//  Copyright (c) 2013年 HaikunZhu. All rights reserved.
//

#import "SpriteViewController.h"
#import "GameScene01.h"



#import "GameKitHelper.h"
@implementation SpriteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  
    
    __weak GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
   localPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error){
        
        [self setLastError:error];
        
        if (viewController!=nil){
            
            [self presentViewController:viewController];
            
        }
        
        else if (localPlayer.authenticated) {
           // _gameCenterFeaturesEnabled = YES;
            
        }
        
        else{
            //_gameCenterFeaturesEnabled = NO;
        }
   };
    
     //[[GameKitHelper shareGameKitHelper] authenticateLocalPlayer];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
//    skView.showsNodeCount = YES;
//    skView.showsFPS = YES;
//    skView.showsDrawCount = YES;
    
    SKScene *mc = [GameScene01 sceneWithSize:skView.bounds.size];
    mc.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:mc];
    

  

 }


#pragma mark Property setters
-(void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR:%@",[[_lastError userInfo] description]);
    }
}
#pragma mark UIViewController stuff
-(UIViewController*)getRootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
-(void)presentViewController:(UIViewController*)vc
{
    
    UIViewController*rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
