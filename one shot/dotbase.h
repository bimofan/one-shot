//
//  dotbase.h
//  one shot
//
//  Created by mac on 13-11-6.
//  Copyright (c) 2013年 HaikunZhu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface dotbase : SKSpriteNode

@property(nonatomic)BOOL appeared;
@property(nonatomic)NSInteger tag;
@property(nonatomic)NSInteger  dotTag;
@property(nonatomic)BOOL freezed;
@property(nonatomic)BOOL AddBlooded;
@property(nonatomic)BOOL  Protected;
@property(nonatomic)BOOL  RemoveAll;

@end
