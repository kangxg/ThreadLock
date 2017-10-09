//
//  consumer.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//
#import "consumer.h"
@interface consumer()
@property (nonatomic,retain)NSCondition * condition;
@property (nonatomic,retain)NSMutableArray * collector;
@property (nonatomic,retain)id          item;
@end
@implementation consumer
-(instancetype)initWithCoordition:(NSCondition *)condition collector:(NSMutableArray *)collector
{
    if (self = [super init])
    {
        /*
         消费者的初始化器用于协调配合的 NSCondition对象和用于存放产品的 collector。初始状态设置为不消费（_shouldConsumer = false）
         */
        _collector     = collector;
        _condition     = condition;
        _shouldConsumer = false;
        self.item      = nil;
    }
    return self;
}

-(void)consumer
{
    _shouldConsumer = YES;
     //消费者会在_shouldConsumer 为YES时 消费者会进行消费。其他线程需要将其设置为NO来停止消费者的消费
    while (_shouldConsumer)
    {
        [_condition lock];//获得 condition的锁 ，进入临界区
        if (_collector.count==0)
        {
            [_condition wait];//如果collector 中没有产品，则 等待，这会阻塞当前线程的执行直到condition 被通知 （signal）为止
        }
        NSString * item = [_collector objectAtIndex:0];
        if (item)
        {
            NSLog(@"消费者%@",item);
            [_collector removeObject:item];//消费collector 中的产品。确保已经从collector 中移除它
        }
        [_condition signal];//通知其他等待的线程（如果存在）。这里标识一个产品被消费并从collector 中移除了
        [_condition unlock];//释放锁
    }
}
@end
