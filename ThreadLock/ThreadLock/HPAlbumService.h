//
//  HPAlbumService.h
//  ThreadLock
//
//  Created by kangxg on 2017/9/30.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPAlbumService : NSObject
+(void)updateAlbums:(NSArray *)albums  completion:(void (^)())completion;
@end
