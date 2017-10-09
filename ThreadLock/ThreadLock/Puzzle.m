//
//  Puzzle.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "Puzzle.h"
@interface Puzzle()
@property (nonatomic,assign)NSInteger anser;
@property (nonatomic,assign)BOOL      anserReady;
@property(retain)dispatch_queue_t serialQueue;
@end
@implementation Puzzle
-(id)init
{
    if (self = [super init])
    {
        _anser = 0;
        _anserReady = false;
        _serialQueue = dispatch_queue_create(DISPATCH_QUEUE_SERIAL, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
-(void)startPuzzle
{
    dispatch_async(self.serialQueue, ^{
        _anser = 42;
        _anserReady = true;
    });
    
    dispatch_async(self.serialQueue, ^{
        while (!_anserReady)
        {
             NSLog(@"Ther meaning of lift is %ld",_anser);
        }

        NSLog(@"I dont't konw the anser");
        
    });
//    dispatch_barrier_async(self.serialQueue, ^{
//         
//    });
}
@end
