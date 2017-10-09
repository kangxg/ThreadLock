//
//  producter.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "producter.h"
@interface producter()
@property (nonatomic,retain)NSCondition * condition;
@property (nonatomic,retain)NSMutableArray * collector;

@property (nonatomic,retain)id          item;
@end
@implementation producter
-(instancetype)initWithCoordition:(NSCondition *)condition collector:(NSMutableArray *)collector
{
    if (self = [super init])
    {
        /*
           生产者的初始化器用于协调配合的 NSCondition对象和用于存放产品的 collector。初始状态设置为不要生产（_shouldProduct = false）
         */
        _collector     = collector;
        _condition     = condition;
        _shouldProduct = false;
        self.item      = nil;
    }
    return self;
}

-(void)product
{
    _shouldProduct = YES;
    //生产者会在_shouldProduct 为YES时进行生产。其他线程需要将其设置为NO以停止生产者的生产
    while (_shouldProduct)
    {
        
        [_condition lock];//获得 condition的锁 ，进入临界区
        if (_collector.count>0)
        {
            [_condition wait];//如果collector 中有未消费的产品，则 等待，这会阻塞当前线程的执行直到condition 被通知 （signal）为止
        }
        NSString * item=[self nextItem];
        NSLog(@"生产者 %@",item);
        [_collector addObject:item];//将生产的 产品送入collector以供消费
        [_condition signal];//通知其他等待的线程（如果存在）。这里是产品完成生产的标志，并将产品加入到collector，可供消费
        [_condition unlock];//释放锁
    }
}
-(id)nextItem
{
    return @"product";
}
@end
