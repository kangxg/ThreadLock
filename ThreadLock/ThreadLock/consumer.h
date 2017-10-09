//
//  consumer.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface consumer : NSObject
@property (nonatomic,assign)BOOL        shouldConsumer;
-(instancetype)initWithCoordition:(NSCondition *)condition collector:(NSMutableArray *)collector;
-(void)consumer;
@end
