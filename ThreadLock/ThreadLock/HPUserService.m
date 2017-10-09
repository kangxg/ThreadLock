//
//  HPUserService.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPUserService.h"
#import "HPSyncService.h"
#import "HPUserBuilder.h"
#import "HPAlbumService.h"
#import "threadHeader.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACSubscriber+Private.h>
#import "threadHeader.h"

//typedef RACDisposable * (^signalBlock)(id<testProtocol>  subscriber);
@interface HPUserService()
@property (nonatomic, strong) NSMutableDictionary * userCache;
@property (nonatomic, strong) HPUserBuilder       * userBuilder;
@end
@implementation HPUserService
+(instancetype)sharedInstance
{
    static HPUserService * instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[HPUserService alloc]init];
    });
    return instance;
}
-(instancetype) init
{  if(self = [super init])
   {
     self.userCache = [NSMutableDictionary dictionary];
     _userBuilder =[[HPUserBuilder alloc]init];
   }
   return self;
}
-(void)userWithId:(NSString *)uid completion:(void (^)(HPUser *))completion
{
    //检查本地缓存或从服务器提取
    HPUser *user = (HPUser *)[self.userCache objectForKey:uid];
    if(user) {
        completion(user);
    }
    [[HPSyncService sharedInstance] fetchType:@"user"
                                       userid:uid completion:^(NSDictionary * data) {
                                           //使用HPUserBuilder，分析数据并构建
                                           HPUser *userFromServer = [_userBuilder build];
                                           [self.userCache setObject:userFromServer forKey:userFromServer.userId];
                                           completion(userFromServer);
                                       }];
}

-(void)updateUser:(HPUser *)user completion:(void (^)(HPUser *))completion
{
    //可能会要求更新到服务器
    [[HPSyncService sharedInstance] updateType:@"user" completion:^(NSDictionary * dic) {
        //使用HPUserBuilder，分析数据并构建
        HPUser *updatedUser = [_userBuilder build];
        [self.userCache setObject:updatedUser forKey:updatedUser.userId];
        [HPAlbumService updateAlbums:updatedUser.albums completion:^{
            completion(updatedUser);
        }];
    }];

}
-(RACSignal *)signalForUserWithId:(NSString *)uid
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber>  subscriber) {
        HPUser *userFromCache = [self.userCache objectForKey:uid];
        if(userFromCache) {
            [subscriber sendNext:userFromCache];
            [subscriber sendCompleted];
            
            
        }else{
            //假设HPSyncService也遵循FRP风格
            RACSignal * racs = [[HPSyncService sharedInstance] loadType:@"user" withId:uid];
            [racs subscribeNext:^(HPUser *userFromServer) {
                //也更新本地缓存和通知
                [subscriber sendNext:userFromServer];
                [subscriber sendCompleted];
            } error: ^(NSError *error) {
                [subscriber sendError:error];
            }];
            
        }
        NSLog(@"创建一个信号");
        return nil;
    }];
    return signal;


}
-(RACSignal *)signalForUpdateUser:(HPUser *)user
{
    // signalForUpdateUser 方法更新一个 HPUser 对象
    //这里创建了 RACSignal。
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber>  subscriber) {
        //        trongifer(strongSelf);
        RACSignal * racs = [[HPSyncService sharedInstance]updateType:@"user" withId:user.userId value:user];
        [racs subscribeNext:^(NSDictionary *data) {
            //使用HPUserBuilder，分析数据并构建
            HPUser *updatedUser = [_userBuilder build];
            id oldUser = [self.userCache objectForKey:updatedUser.userId];
            [self.userCache setObject:updatedUser forKey:updatedUser.userId];
            [subscriber sendNext:updatedUser];
            [subscriber sendCompleted];
            //当用户被更新，你不仅需要通知直接订阅者，还要通知观察者更新缓存。
            [self notifyCacheUpdatedWithUser:updatedUser old:oldUser];
        } error:^(NSError * _Nullable error) {
             [subscriber sendError:error];
        }];
        NSLog(@"创建一个信号");
        return nil;
    }];
    return signal;
}
//notifyCacheUpdatedWithUser:old: 广播了用户对象的变化
-(void)notifyCacheUpdatedWithUser:(HPUser *)user old:(HPUser *)oldUser {
    NSDictionary *tuple = @{
                           @"old": oldUser,
                           @"new": user
                          };
    //这里使用 NSNotificationCenter 是为了简化。这个方法不宜暴露给 HPUserService 类的用户。这是个扩展方法。
    [NSNotificationCenter.defaultCenter postNotificationName:@"userUpdated" object:tuple];
}

-(RACSignal *)signalForUserUpdates:(id)object
{
    //这里使用了ReactiveCocoa框架提供的分类扩展rac_addObserverForName，以订阅 userUpdated 通知。它也会实际从 NSNotification 中抽取 NSDictionary，后者由旧的和 新的用户对象所组成。
    return [[NSNotificationCenter.defaultCenter rac_addObserverForName:@"userUpdated" object:object]   flattenMap:^(NSNotification *note) {
        return note.object; }];
}
@end
