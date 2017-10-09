//
//  HPAlbum.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPPhoto;
@class HPUser;
@interface HPAlbum : NSObject
@property (nonatomic, copy) NSString  *  albumId;
@property (nonatomic, strong)HPUser   *  owner;
@property (nonatomic, copy) NSString  *  name;
@property (nonatomic, copy) NSString  *  descrip;
@property (nonatomic, copy) NSDate    *  creationTime;
@property (nonatomic, copy) HPPhoto   *  coverPhoto;


-(void) freeze;
@end
