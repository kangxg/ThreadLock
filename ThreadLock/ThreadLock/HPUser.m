//
//  HPUser.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPUser.h"
#import "HPUserBuilder.h"
@interface HPUser()
@property (nonatomic, assign) BOOL frozen;
@end

@implementation HPUser
@synthesize userId       =  _userId;
@synthesize firstName    =  _firstName;
@synthesize lastName     =  _lastName;
@synthesize gender       =  _gender;
@synthesize dateOfBirth  =  _dateOfBirth;
@synthesize albums       =  _albums;
-(void)freeze
{
    self.frozen = YES;
}

-(void)setUserId:(NSString *)userId
{
    if (!self.frozen)
    {
        _userId = userId;
    }
}

-(void)setFirstName:(NSString *)firstName
{
    if (!self.frozen)
    {
        _firstName = firstName;
    }
}

-(void)setLastName:(NSString *)lastName
{
    if (!self.frozen)
    {
        _lastName = lastName;
    }
}

-(void)setGender:(NSString *)gender
{
    if (!self.frozen)
    {
        _gender = gender;
    }
}

-(void)setDateOfBirth:(NSDate *)dateOfBirth
{
    if (!self.frozen)
    {
        _dateOfBirth = dateOfBirth;
    }
}

-(void)setAlbums:(NSArray *)albums
{
    if (!self.frozen)
    {
        _albums = albums;
    }
}
-(instancetype) initWithBuilder:(HPUserBuilder *)builder {
    if(self = [super init]) {
        self.userId      =   builder.userId;
        self.firstName   =   builder.firstName;
        self.lastName    =   builder.lastName;
        self.gender      =   builder.gender;
        self.dateOfBirth =   builder.dateOfBirth;
        self.albums = [NSArray arrayWithArray:builder.albums];
    }
    return self;
    
}

+(instancetype) userWithBlock:(void (^)(HPUserBuilder *))block
{
    HPUserBuilder *builder = [[HPUserBuilder alloc] init];
    block(builder);
    return [builder build];
}
@end
