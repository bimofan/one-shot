//
//  GameKitHelper.h
//  captainjack
//
//  Created by haikunzhu on 13-10-4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@protocol GameKitHelperProtocol <NSObject>
//scores
-(void)onScoresSubmitted:(bool)success;

@end
@interface GameKitHelper : NSObject
@property (nonatomic ,assign) id<GameKitHelperProtocol>delegate;

@property(nonatomic,readonly)NSError*lastError;

+(id)shareGameKitHelper;
-(void)authenticateLocalPlayer;

//scores
-(void)submitScore:(int64_t)score
          category:(NSString*)category;
@end
