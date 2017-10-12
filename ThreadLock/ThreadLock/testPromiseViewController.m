//
//  testPromiseViewController.m
//  ThreadLock
//
//  Created by kangxg on 2017/10/12.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "testPromiseViewController.h"

@implementation testPromiseViewController
{
     PMKResolver resolve;
}
@synthesize promise = _promise;
-(id)init
{
    if (self = [super init])
    {
        _promise = [[AnyPromise alloc] initWithResolver:&resolve];
    }
    return self;
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor yellowColor];
    [self later];
    
}
- (void)later {
    resolve(@"some fulfilled value");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
