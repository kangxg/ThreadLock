//
//  HPSyncService.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPSyncService.h"

@implementation HPSyncService
+(HPSyncService *)sharedInstance
{
    static HPSyncService * instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[HPSyncService alloc]init];
    });
    return instance;
}
-(RACSignal *)loadType:(NSString *)type  withId:(NSString *)userId
{
    return nil;
}
-(void)fetchType:(NSString *)type  userid:(NSString *)userId completion:(void (^)(NSDictionary *))completion
{
    NSDictionary  * dic = [NSDictionary new];
    completion(dic);
}

-(void)updateType:(NSString *)type completion:(void (^)(NSDictionary *))completion
{
    NSDictionary  * dic = [NSDictionary new];
    completion(dic);
}

-(RACSignal *)updateType:(NSString *)type  withId:(NSString *)userId value:(HPUser *)user
{
    return nil;
}
@end
