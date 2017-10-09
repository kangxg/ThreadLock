//
//  HPUserService.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPUser.h"
@class RACSignal;
@interface HPUserService : NSObject
/*
 HPUserService 遵循了单例模式，通常而言，在实体或服务层次使 用单例并非明智的选择，
 因为这会带来紧密的耦合并影响 mock 框架的使用。
 此时，使 用可配置的工厂要优于使用单例。工厂可以创建可销毁的单例。
 */
+(instancetype)sharedInstance;

-(void)userWithId:(NSString *)uid completion:(void (^)(HPUser *))completion;

-(void)updateUser:(HPUser *)user completion:(void (^)(HPUser *))completion;

-(RACSignal *)signalForUserWithId:(NSString *)uid;

-(RACSignal *)signalForUpdateUser:(HPUser *)user;

-(RACSignal *)signalForUserUpdates:(id)object;
@end
