//
//  Counter.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "Counter.h"
@interface Counter()
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,retain)NSLock * lock;
@end
@implementation Counter
-(id)init
{
    if (self = [super init])
    {
        _count = 0;
        _lock = [[NSLock alloc]init];
    }
    return self;
}

-(void)increment
{
    [_lock lock];
    ++ _count;
    [_lock unlock];
}
-(NSInteger)getCount
{
    return _count;
}
@end
