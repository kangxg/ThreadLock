//
//  Coordinator.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "Coordinator.h"
#import "producter.h"
#import "consumer.h"
@implementation Coordinator


-(void)start
{
    NSMutableArray * pipeline = [NSMutableArray new];
    NSCondition * condition = [NSCondition new];//Coordinator 类为生产者和消费者准备好了输入数据（具体指的是condition和collector）
    //设置生产者和消费者
    producter * p = [[producter alloc]initWithCoordition:condition collector:pipeline];
    consumer  * c = [[consumer alloc]initWithCoordition:condition collector:pipeline];
    
    //在不同的线程中开启生产和消费任务
    [NSThread detachNewThreadSelector:@selector(startProduct:) toTarget:self withObject:p] ;
    [NSThread detachNewThreadSelector:@selector(startConsumer:) toTarget:self withObject:c];
    //一旦完成，分别设置生产者和消费者停止生产和消费
    p.shouldProduct  = false;
    c.shouldConsumer = false;
    //因为生产者和消费者线程可能会等待，所以broadcast本质上会通知所有等待中的线程。不同的是，signal 方法 只会影响一个等待的线程
    [condition broadcast];

}

-(void)startProduct:(id)sender
{
    //开始生产
    producter * p = sender;
    [p product];
}

-(void)startConsumer:(id)sender
{
    //开始消费
    consumer * c = sender;
    [c consumer];
}
@end
