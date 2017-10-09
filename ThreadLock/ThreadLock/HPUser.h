//
//  HPUser.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPUserBuilder;
@interface HPUser : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSDate *dateOfBirth;
@property (nonatomic, strong) NSArray *albums;

/**
 Description 模型提供了类方法 userWithBlock
 */
+(instancetype) userWithBlock:(void (^)(HPUserBuilder *))block;

/**
 Description 模型的私有扩展——自定义的初始化器
 */
-(instancetype) initWithBuilder:(HPUserBuilder *)builder;

-(void) freeze; 
@end
