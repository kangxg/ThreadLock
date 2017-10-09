//
//  HPUserBuilder.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPUserBuilder.h"

@implementation HPUserBuilder
-(HPUser *) build
{
    return [[HPUser alloc] initWithBuilder:self];
}


-(instancetype) initWithUser:(HPUser *)user
{
    if(self = [super init])
    {
    self.userId = user.userId;
    self.firstName = user.firstName;
    self.lastName = user.lastName;
    self.gender = user.gender;
    self.dateOfBirth = user.dateOfBirth;
    self.albums = user.albums;
    }
    return self;
}
@end
