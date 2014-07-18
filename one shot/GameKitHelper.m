//
//  GameKitHelper.m
//  fish01
//
//  Created by mac on 13-10-4.
//
//

#import "GameKitHelper.h"

@interface  GameKitHelper()
  <GKGameCenterControllerDelegate>{
    BOOL _gameCenterFeaturesEnabled;
}

@end

@implementation GameKitHelper

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    
}
-(void)submitScore:(int64_t)score category:(NSString *)category
{
    if (!_gameCenterFeaturesEnabled) {
        NSLog(@"Player not authenticated");
        return;
    }
    GKScore*gkscore = [[GKScore alloc]initWithLeaderboardIdentifier:category];
    gkscore.value = score;
    [gkscore reportScoreWithCompletionHandler:^(NSError*error){
        [self setLastError:error];
        BOOL success = (error == nil);
        if ([_delegate respondsToSelector:@selector(onScoresSubmitted:)]) {
            [_delegate onScoresSubmitted:success];
        }
    }];
}
#pragma mark Singeton stuff
+(id)shareGameKitHelper
{
    static GameKitHelper *shareGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareGameKitHelper=[[GameKitHelper alloc]init];
    });
    
    return shareGameKitHelper;
}

#pragma  mark Player Authentication
-(void)authenticateLocalPlayer
{
    
    NSLog(@"authenticati");
    
   __weak GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error){
        
        [self setLastError:error];
        
         if (viewController!=nil){
           
            [self presentViewController:viewController];
            
        }
        
         else if (localPlayer.authenticated) {
             _gameCenterFeaturesEnabled = YES;
             
         }
        
        else{
            _gameCenterFeaturesEnabled = NO;
        }
    };
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
@end