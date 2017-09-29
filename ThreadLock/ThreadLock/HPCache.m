//
//  HPCache.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/28.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPCache.h"
@interface HPCache()
@property (nonatomic,readonly,retain)NSMutableDictionary * cacheObjects;
@property (nonatomic,retain,readonly)dispatch_queue_t     queue;

@end
@implementation HPCache
-(instancetype)init
{
    if (self = [super init])
    {
        _cacheObjects = [NSMutableDictionary new];
        _queue = dispatch_queue_create("kCacheQueueName", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

+(HPCache *)sharedInstance
{
    static HPCache * instance = nil;
    static dispatch_once_t onceToken;
  
    dispatch_once(&onceToken, ^{
        instance = [[HPCache alloc]init];
    });
    return instance;
}

-(id)objectForKey:(id<NSCopying>)key
{
    __block id rv = nil;
    dispatch_sync(self.queue, ^{
        rv = [self.cacheObjects objectForKey:key];
    });
    return rv;
}

-(void)setObject:(id)object forKey:(id)key
{
    dispatch_barrier_async(self.queue, ^{
         [self.cacheObjects setObject:object forKey:key];
    });

}
@end
