//
//  HPUserBuilder.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPUser.h"

/**
 Description  生成器
 */
@interface HPUserBuilder : NSObject
@property (nonatomic, copy) NSString *  userId;
@property (nonatomic, copy) NSString *  firstName;
@property (nonatomic, copy) NSString *  lastName;
@property (nonatomic, copy) NSString *  gender;
@property (nonatomic, copy) NSDate   *  dateOfBirth;
@property (nonatomic, strong)NSArray *  albums;

-(HPUser *)build;
/*
 HPUserBuilder 现在有了另一个自定义初始化器。它以 HPUser 对象作为输入参数，
 并利 用 user 对象的值对自身进行初始化。可以通过属性的 setter 方法修改状态，
 并最终使用并发编程  build 方法构造新的对象。
 注意，虽然状态被修改，但旧的对象却没有发生任何改动。
 这也意味着，如果旧的对象正被其他实体(如视图控制器)所使用，则需要进行替换。
 */
-(instancetype) initWithUser:(HPUser *)user;
@end
