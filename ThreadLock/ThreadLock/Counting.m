//
//  Counting.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "Counting.h"
#import "Counter.h"
@interface Counting()
@property(retain)dispatch_queue_t serialQueue;
@end
@implementation Counting
-(id)init
{
    if (self = [super init])
    {
        _serialQueue = dispatch_queue_create(DISPATCH_QUEUE_SERIAL, DISPATCH_QUEUE_CONCURRENT);
        
    }
    return self;
}

-(void)startCounting
{
    Counter * counter = [[Counter alloc]init];
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i<10000; ++i)
        {
            [counter increment];
        }
    });
    
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i<10000; ++i)
        {
            [counter increment];
        }
    });
    dispatch_barrier_async(self.serialQueue, ^{
        NSLog(@"%ld",[counter getCount]);
    });
}
@end
