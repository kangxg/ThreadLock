//
//  HPAlbum.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "HPAlbum.h"
@interface HPAlbum()
@property (nonatomic, assign) BOOL frozen;
@end

@implementation HPAlbum
@synthesize owner         = _owner;
@synthesize name          = _name;
@synthesize albumId       = _albumId;
@synthesize descrip       = _descrip;
@synthesize creationTime  = _creationTime;
@synthesize coverPhoto    = _coverPhoto;
-(void)freeze
{
    self.frozen = YES;
}

-(void)setOwner:(HPUser *)owner
{
    if (!self.frozen)
    {
        _owner = owner;
    }
}

-(void)setName:(NSString *)name
{
    if (!self.frozen)
    {
        _name = name;
    }
}

-(void)setAlbumId:(NSString *)albumId
{
    if (!self.frozen)
    {
        _albumId = albumId;
    }
}

-(void)setDescrip:(NSString *)descrip
{
    if (!self.frozen)
    {
        _descrip = descrip;
    }
}

-(void)setCreationTime:(NSDate *)creationTime
{
    if (!self.frozen)
    {
        _creationTime = creationTime;
    }
}

-(void)setCoverPhoto:(HPPhoto *)coverPhoto
{
    if (!self.frozen)
    {
        _coverPhoto = coverPhoto;
    }
}
@end
