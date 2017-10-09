//
//  HPPhoto.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HPUser;
@class HPAlbum;
@interface HPPhoto : NSObject
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, strong) HPAlbum *album;
@property (nonatomic, strong) HPUser *user;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) CGSize size;
@end
