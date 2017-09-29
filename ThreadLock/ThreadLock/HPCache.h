//
//  HPCache.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/28.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCache : NSObject
+(HPCache *)sharedInstance;

-(id)objectForKey:(id)key;

-(void)setObject:(id)object forKey:(id)key;
@end
