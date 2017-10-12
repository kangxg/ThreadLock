//
//  testPromiseViewController.h
//  ThreadLock
//
//  Created by kangxg on 2017/10/12.
//  Copyright © 2017年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PromiseKit/PromiseKit.h>
@interface testPromiseViewController : UIViewController
@property (nonatomic,retain,readonly) AnyPromise * promise;
- (void)later;
@end
