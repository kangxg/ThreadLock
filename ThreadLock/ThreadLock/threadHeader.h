//
//  threadHeader.h
//  ThreadLock
//
//  Created by kangxg on 2017/10/1.
//  Copyright © 2017年 zy. All rights reserved.
//

#ifndef threadHeader_h
#define threadHeader_h

#define weakifer(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define trongifer(strongSelf) __strong __typeof(&*self)strongSelf = self;
#endif /* threadHeader_h */
