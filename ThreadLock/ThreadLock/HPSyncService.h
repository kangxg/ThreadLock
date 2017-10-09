//
//  HPSyncService.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HPUser.h"
@interface HPSyncService : NSObject
+(HPSyncService *)sharedInstance;

-(void)fetchType:(NSString *)type  userid:(NSString *)userId completion:(void (^)(NSDictionary *))completion;

-(RACSignal *)loadType:(NSString *)type  withId:(NSString *)userId;

-(void)updateType:(NSString *)type completion:(void (^)(NSDictionary *))completion;

-(RACSignal *)updateType:(NSString *)type  withId:(NSString *)userId value:(HPUser *)user;
@end
