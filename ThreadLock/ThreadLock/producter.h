//
//  producter.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/29.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface producter : NSObject
@property (nonatomic,assign)BOOL        shouldProduct;
-(instancetype)initWithCoordition:(NSCondition *)condition collector:(NSMutableArray *)collector;
-(void)product;
@end
