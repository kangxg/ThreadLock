//
//  ViewController.m
//  ThreadLock
//
//  Created by kangxg on 2017/9/28.
//  Copyright © 2017年 zy. All rights reserved.
//

#import "ViewController.h"
#import "Counting.h"
#import "Puzzle.h"
#import "Coordinator.h"
#import "HPUserBuilder.h"
#import "HPAlbum.h"
#import "HPUserService.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "Person.h"
@interface ViewController ()
@property (nonatomic, strong)  UILabel        *  nameLabel;
@property (nonatomic, strong)  UITextField    *  nameText;
@property (nonatomic, strong)  UITextField    *  passWordText;
@property (nonatomic, strong)  UIButton       *  loginButton;
@property (nonatomic, strong)  Person         *  person;
@property (nonatomic, strong)  UIButton       *  hightButton;
@property (nonatomic)      RACDelegateProxy   *  proxy;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self runCoordinator];
   // [self runCounting];
    //[self createUser];
    [self createUI];
//    [self demoKvo];
//    [self textFileCombination];
//    [self buttonDemo];
//    [self delegateDemo];
//    [self notificationDemo];
    //[self nameTextFieldChange];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)runCounting
{
    Counting * counting = [[Counting alloc]init];
    [counting startCounting];
}
-(void)runPuzzle
{
    Puzzle * puzzle = [[Puzzle alloc]init];
    [puzzle startPuzzle];
}

-(void)runCoordinator
{
    Coordinator * coord = [[Coordinator alloc]init];
    [coord start];
}

/**
 Description 用生成器创建HPUser对象的使用示例。
 */
-(HPUser *) createUser
{
    HPUser *rv = [HPUser userWithBlock:^(HPUserBuilder *builder) {
        builder.userId = @"id001";
        builder.firstName = @"Alice";
        builder.lastName = @"Darji";
        builder.gender = @"F";
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:1980];
        [components setMonth:1];
        [components setDay:1];
        builder.dateOfBirth = [cal dateFromComponents:components];
        builder.albums = [NSArray array];
    }];
    NSLog(@"user.firstName:%@",rv.firstName);
    return rv;
    
}

-(HPUser *)sampleUser {
    //演示新 API 使用的示例代码
    HPUser *user = [[HPUser alloc] init];

    user.userId = @"user-1";
    user.firstName = @"Bob";
    user.lastName = @"Taylor";
    user.gender = @"M";
    HPAlbum *album1 = [[HPAlbum alloc] init];
    //将一个用户设置为相册的持有者。此时，两个对象都是可变类型的。
    album1.owner = user;
    album1.name = @"Album 1";
    //......其他属性
    [album1 freeze]; //将 HPAlbum 对象标记为不可变。
    HPAlbum *album2 = [[HPAlbum alloc] init]; album2.owner = user;
    album2.name = @"Album 2";
    //......其他属性
    [album2 freeze];
    
    user.albums = [NSArray arrayWithObjects:album1, album2, nil];
    [user freeze];//将 HPUser 对象标记为不可变。注意，只有在这之前才可以使用不可变的相册对象
    return user;
}

//在应用的其他地方
-(void)retrieveAUser:(NSString *)userId
{
      [[[HPUserService sharedInstance] signalForUserWithId:userId] subscribeNext:^(HPUser *user) {
          //处理用户，或者更新
          
      } error:^(NSError * error) {
          //向用户显示错误
          
      }];
}
-(void)updateAUser:(HPUser *)user
{
    [[[HPUserService sharedInstance]signalForUpdateUser:user] subscribeNext:^(HPUser *user) {
        //处理用户，或者更新
        
    } error:^(NSError * error)
    {
        //向用户显示错误
        
    }];
        
}
//监听用户更新
-(void) watchForUserUpdates
{
    [[[HPUserService sharedInstance] signalForUserUpdates:self]
     subscribeNext:^(NSDictionary *tuple) {
         //用值做一些事情
         HPUser *oldUser = [tuple objectForKey:@"old"];
         HPUser *newUser = [tuple objectForKey:@"new"];
     }];
    
}

#pragma mark 响应式编程
-(void)createUI
{
    [self.view addSubview:self.nameLabel];
//    [self.view addSubview:self.nameText];

//    [self.view addSubview:self.passWordText];
//    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.hightButton];
    [self ChannelSignal];
    //    [self distinctUntilChangedSignal];
    
}
- (Person *)person
{
    if (!_person)
    {
        _person = [[Person alloc] init];
        
    }
    return _person;
}
-(UILabel *)nameLabel
{
    if (_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 30)];
        _nameLabel.backgroundColor = [UIColor grayColor];
        _nameLabel.textColor = [UIColor redColor];
    }
    return _nameLabel;
}

-(UITextField *)nameText
{
    if (_nameText == nil)
    {
        _nameText = [[UITextField alloc]initWithFrame:CGRectMake(10, 140, 100, 30)];
        _nameText.backgroundColor = [UIColor grayColor];
        _nameText.textColor = [UIColor greenColor];
       
    }
    return _nameText;
}

-(UITextField *)passWordText
{
    if (_passWordText == nil)
    {
        _passWordText = [[UITextField alloc]initWithFrame:CGRectMake(10, 210, 100, 30)];
        _passWordText.backgroundColor = [UIColor grayColor];
        _passWordText.textColor = [UIColor orangeColor];
    }
    return _passWordText;
}
-(UIButton *)loginButton
{
    if (_loginButton == nil)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, 260, 60, 30);
        [_loginButton setTitle:@"log" forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor greenColor];
        [_loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }
    return _loginButton;
}


/** * 1、为了测试此函数，增加了一个Person类 && 一个Label；点击屏幕则会等改Lable的值 */
#pragma -mark KVO 监听
- (void)demoKvo
{
    @weakify(self)
    [RACObserve(self.person, name) subscribeNext:^(id x)
                {
                    @strongify(self)
                    self.nameLabel.text = x;
                    
                }];
    
}
/**
 * 增加 UITextField：nameText 监听文本框的输入内容，并设置为self.person.name
 */
-(void)nameTextFieldChange
{
    @weakify(self);
    [[self.nameText rac_textSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"%@",x);
         self.person.name = x;
     }];
}

/**
 * 3、为了验证此函数，增加了一个passwordText和一个Button，监测nameText和passwordText
 * 根据状态是否enabled
 */
- (void)textFileCombination
{
    
    id signals = @[[self.nameText rac_textSignal],[self.passWordText rac_textSignal]];
    
    @weakify(self);
    [[RACSignal
      combineLatest:signals]
     subscribeNext:^(RACTuple *x) {
         
         @strongify(self);
         NSString *name = [x first];
         NSString *password = [x second];
         
         if (name.length > 0 && password.length > 0) {
             
             self.loginButton.enabled = YES;
             self.person.name = name;
             self.person.password = password;
             self.loginButton.backgroundColor = [UIColor blueColor];
             
         } else  {
             self.loginButton.enabled = NO;
             self.loginButton.backgroundColor = [UIColor grayColor];
             
         }
     }];
    
}

/** * 验证此函数：当loginButton可以点击时，点击button输出person的属性，实现监控的效果 */
- (void)buttonDemo
{
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
                                    subscribeNext:^(id x) {
                                        @strongify(self);
                                        NSLog(@"person.name: %@ person.password: %@",self.person.name,self.person.password);
                                    } error:^(NSError * _Nullable error) {
                                        
                                    } completed:^{
                                        
                                    }];
    
}

/**
 * 验证此函：nameText的输入字符时，输入回撤或者点击键盘的回车键使passWordText变为第一响应者（即输入光标移动到passWordText处）
 */
- (void)delegateDemo {

    @weakify(self)
    // 1. 定义代理
    self.proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
    // 2. 代理去注册文本框的监听方法
    [[self.proxy rac_signalForSelector:@selector(textFieldShouldReturn:)]
     subscribeNext:^(id x) {
         @strongify(self)
         if (self.nameText.hasText) {
             [self.passWordText becomeFirstResponder];
         }
     }];
    self.nameText.delegate = (id<UITextFieldDelegate>)self.proxy;
}

/**
 * 验证此函数：点击textFile时，系统键盘会发送通知，打印出通知的内容
 */
- (void)notificationDemo {
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]
     subscribeNext:^(id x) {
         NSLog(@"notificationDemo : %@", x);
     }
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 高级用法
-(void)flattenMap
{
    //map，将输出NSNumber的signal 输出为NSString
    RACSignal *mapSignal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber)
                                 {
                                 [subscriber sendNext:@(1)];
                                 return nil;
                                 }]
                                 map:^id _Nullable(id _Nullable value)
                                 {
                                  return @"map";
                
                                 }
                            ];
    [mapSignal subscribeNext:^(id _Nullable x)
   {
     //NSString类型
        NSLog(@"x");
        
    }];

}
-(void)mergeMap
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                            [subscriber sendNext:@(1)];
                            return nil;
        
                          }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                            [subscriber sendNext:@(2)];
                            return nil;
        
                         }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                             [subscriber sendNext:@(3)];
                             return nil;
        
                         }];
    RACSignal *mergeSignal = [RACSignal merge:@[signal1,signal2,signal3]];
    [mergeSignal subscribeNext:^(id _Nullable x) {
        //分别输出1,2,3
        NSLog(@"--%@--",x);
        
    }];
        
}

-(void)concatMap
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                                    [subscriber sendNext:@(1)];
                                    //发送信号完成，表示不再订阅了，内部会自动调用[RACDisposable disposable]取消订阅信号。
                                     [subscriber sendCompleted];
                                     return nil;
                         }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                                    [subscriber sendNext:@(2)];
                                    [subscriber sendCompleted];
                                     return nil;
                         }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
                                    [subscriber sendNext:@(3)];
                                    [subscriber sendCompleted];
                                    return nil;
        
    }];
    RACSignal *concatSignal = [RACSignal concat:@[signal2,signal1,signal3]];
    [concatSignal subscribeNext:^(id _Nullable x)
    {
        //分别输出2,1,3
        NSLog(@"%@",x);
        
    }];
        
}

-(void)thenSignal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        //发送信号完成，表示不再订阅了，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *thenSignal = [signal1 then:^RACSignal * _Nonnull{
        return   [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
            [subscriber sendNext:@(2)];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [thenSignal subscribeNext:^(id _Nullable x)
     {
         //输出2
         NSLog(@"%@",x);
         
     }];
}

-(void)zipSignal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        return nil;
        
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(2)];
        return nil;
        
    }];
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(3)];
        return nil;
        
    }];
    RACSignal *zipSignal = [RACSignal zip:@[signal1,signal2,signal3]];
    [zipSignal subscribeNext:^(id _Nullable x) {
        //分别输出1,2,3
        NSLog(@"--%@--",x);
        
    }];
}


-(void)combineLatestSingnal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        //将覆盖之前的信号，这就是跟zip的区别
        [subscriber sendNext:@(3)];
        return nil;
        
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(2)];
        return nil;
        
    }];
    //如果其中一个信号不sendNext，则不会触发组合信号
    RACSignal *combineSignal = [RACSignal combineLatest:@[signal1,signal2] ];
    [combineSignal subscribeNext:^(id _Nullable x) {
        //输出(3,2)
        NSLog(@"combineLatest:%@",x);
        
    }];
    
}

-(void)liftSelectorSignalsFromArray
{
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[self rac_liftSelector:@selector(updateWithParameter1:parameter2:) withSignals:subject1,subject2, nil] subscribeNext:^(id _Nullable x)
        {
            NSLog(@"liftSelectorSignals : %@",x);
            
        }
     ];
    [subject1 sendNext:@1];
    [subject2 sendNext:@2];

}

-(void)updateWithParameter1:(id)p1 parameter2:(id)p2
{
    NSLog(@"p1:%@-p2:%@",p1,p2);
}


-(void)reduceEachSignal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        return nil;
        
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(2)];
        return nil;
        
    }];

    RACSignal *combineSignal = [RACSignal combineLatest:@[signal1,signal2] ];
    RACSignal *reduceSignal = [combineSignal reduceEach:^id (NSNumber *num1,NSNumber *num2)
                                  {
                                   return @(num1.doubleValue+num2.doubleValue);
                                   
                                  }
                               ];
    [reduceSignal subscribeNext:^(id _Nullable x) {
        //输出3
        NSLog(@"reduceEachSignal:%@",x);
        
    }];
}

-(void)filterSignal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(3)];
        return nil;
        
    }];
    
    RACSignal *filterSignal = [signal1 filter:^BOOL(id _Nullable value) {
                                 return [value isKindOfClass:[NSNumber class]];
        
                               }];
    [filterSignal subscribeNext:^(id _Nullable x) {
                                //输出1
                                 NSLog(@"filterSignal-subscribeNext:%@",x);
        
                                }
     ];
    //数组的筛选
    RACSequence *sequence = [@[@(1),@(2),@"3"].rac_sequence filter:^BOOL(id _Nullable value) {
        return [value isKindOfClass:[NSNumber class]];
        
    }];
    [sequence.signal subscribeNext:^(id _Nullable x) {
        //输出1，2
        NSLog(@"filterSignal-sequence:%@",x);
        
    }];
}
-(void)distinctUntilChangedSignal
{
    [_nameText.rac_textSignal.distinctUntilChanged subscribeNext:^(NSString * _Nullable x) {
        //变化时输出变化之后的值
        NSLog(@"distinctUntilChangedSignal-textChange:%@",x);
    }];
}
-(void)takeSignal
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(3)];
        return nil;
        
    }]take:1];
    [signal subscribeNext:^(id  _Nullable x) {
        //输出1，因为take为1，所以有效的只有最开始的那一个，其他的忽略掉了
        NSLog(@"takeSignal:%@",x);
    }];
}



-(void)taskLastSignal
{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendCompleted]; return nil;
        
    }] takeLast:1] subscribeNext:^(id _Nullable x)
     {
         //输出2
         NSLog(@"taskLastSignal:%@",x);
         
     }];

}
-(void)takeUntilSignal
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        return nil;
        
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(2)];
        return nil;
        
    }];
    [[signal1 takeUntil:signal2] subscribeNext:^(id  _Nullable x) {
        //什么都不会输出，因为signal2已经sendNext，所以signal1就会失效
        NSLog(@"takeUntilSignal:%@",x);
    }];
}
-(void)skipSignal
{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)]; return nil;
        
    }] skip:2] subscribeNext:^(id _Nullable x) {
        //输出3
        NSLog(@"skipSignal:%@",x);
        
    }];
        
}
-(void)doNextSignal
{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        return nil;
        
    }] doNext:^(id _Nullable x) {
        x = [NSString stringWithFormat:@"doNextSignal - doNext:%@",x];
        //输出doNextSignal - doNext:1，在订阅回调之前执行
        NSLog(@"%@",x);
        
    }] subscribeNext:^(id _Nullable x) {
        //输出doNextSignal-subscribeNext:1
        NSLog(@"doNextSignal-subscribeNext%@",x);
        
    }];
}


-(void)timeoutSignal
{
    RACSubject *subject = [RACSubject subject];
    [[subject timeout:3 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id _Nullable x) {
        //只输出1
        NSLog(@"timeoutSignal:%@",x);
        
    } error:^(NSError * _Nullable error) {
        //3秒之后输出错误日志
        NSLog(@"timeoutSignal-error:%@",error);
    }];
   [subject sendNext:@1];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [subject sendNext:@2]; });
    
}


//定时，每隔一定时间发出时间信号。
-(void)intervalSignal
{
    //RACScheduler:队列
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        //每隔一秒输出当前时间
        NSLog(@"intervalSignal:%@",x);
        
    }];
}

//延时发送信号
-(void)delaySignal
{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(1)];
        return nil;
        
    }] delay:3] subscribeNext:^(id _Nullable x) {
        //3秒之后输出1
        NSLog(@"delaySignal%@",x);
        
    }];
}

//重试，只要失败，就会重新执行创建信号中的block,直到成功。
-(void)retrySignal
{
    __block NSInteger i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        i++;
    if (i > 10) {
        [subscriber sendNext:@"我尝试重试了！"];
        
    }else{
        [subscriber sendError:nil];
        
    }
        return nil;
        
    }] retry] subscribeNext:^(id _Nullable x) {
        //重试10次之后输出信息
        NSLog(@"retrySignal:%@",x);
        
    }error:^(NSError * _Nullable error) {
        NSLog(@"retrySignal-error%@",error);
        
    }];
    
}

-(void)throttleSignal
{
    RACSubject *subject = [RACSubject subject];
    // [subject bufferWithTime:1 onScheduler:[RACScheduler currentScheduler]];
    [[subject throttle:1] subscribeNext:^(id _Nullable x) {
        //输出3，拿到最后发出的内容3
        NSLog(@"throttleSignal:%@",x);
        
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];

}
-(void)flattenSignal
{
    RACSubject *subject = [RACSubject subject];
    RACSubject *subSubject1 = [RACSubject subject];
    RACSubject *subSubject2 = [RACSubject subject];
    [subject subscribeNext:^(id _Nullable x) {
        //分别输出subSubject1，subSubject2，但是不能拿到其中的值
        NSLog(@"subject subscribeNext:%@",x);
        
    }];
    [subject.flatten subscribeNext:^(id _Nullable x) {
        //分别输出1，2, flatten可以拿到所有子信号发送的值
        NSLog(@":subject.flatten%@",x);
        
    }];
    [subject sendNext:subSubject1];
    [subject sendNext:subSubject2];
    [subSubject1 sendNext:@1];
    [subSubject2 sendNext:@2];

}
-(void)switchToLatestSignal
{
    RACSubject *subject = [RACSubject subject];
    RACSubject *subSubject1 = [RACSubject subject];
    RACSubject *subSubject2 = [RACSubject subject];
    [subject subscribeNext:^(id _Nullable x) {
        //分别输出subSubject1，subSubject2，但是不能拿到其中的值
        NSLog(@"subject subscribeNext:%@",x);
        
    }];
    [subject.switchToLatest subscribeNext:^(id  _Nullable x) {
        //输出2, switchToLatest只会拿到最新的子信号发送的值
        NSLog(@"subject.switchToLatest:%@",x);
    }];
    [subject sendNext:subSubject1];
    [subject sendNext:subSubject2];
    [subSubject1 sendNext:@1];
    [subSubject2 sendNext:@2];
}
-(UIButton *)hightButton
{
    if (_loginButton == nil)
    {
        _hightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hightButton.frame = CGRectMake(120, 160, 160, 30);
        [_hightButton setTitle:@"高级用法" forState:UIControlStateNormal];
        _hightButton.backgroundColor = [UIColor greenColor];
        [_hightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        @weakify(self);
        [[_hightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             [self commandSignal];
         } ];
        
    }
    return _hightButton;
}
-(void)replaySubject
{
    RACReplaySubject *replaySubject = [RACReplaySubject replaySubjectWithCapacity:5];
    [replaySubject sendNext:@1];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        //输出1
        NSLog(@"%@",x);
    }];
}
-(void)multicastConnectionSignal
{
    __block int i = 0;
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        [subscriber sendNext:@(i)];
        i ++;
        NSLog(@"%d",i);
        return nil;
        
    }];
    //创建RACMulticastConnection对象
    RACMulticastConnection *connect = [signal publish] ;
    [connect.signal subscribeNext:^(id _Nullable x) {
        //输出0
        NSLog(@"%@",x);
        
    }];
    [connect.signal subscribeNext:^(id _Nullable x) {
        //输出0,当再次订阅时，不会再执行didSubscribe，所以并没有i++
        NSLog(@"%@",x);
    }];
    //连接
    [connect connect];

}
-(void)commandSignal
{
    //1.创建命令对象
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //输出1,由execute传入
        NSLog(@"SignalInput:%@",input);
        //2.创建信号
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@(2)];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //获取信号传输的数据
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        //输出2
        NSLog(@"%@",x);
    }];
    //这里用flatten跟switchToLatest也是一样的
    [[command.executionSignals flatten] subscribeNext:^(id  x) {
        //输出2
        NSLog(@"%@",x);
    }];
    //监听命令是否执行完毕,初始化时会调用一次，用skip直接跳过。
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
        }else{
            // 执行完成
            NSLog(@"执行完成");
        } }];
    //3.执行命令
    RACSignal *connectSignal = [command execute:@(1)] ;
    [connectSignal subscribeNext:^(id  x) {
        //输出2，connectSignal是connect.signal
        NSLog(@"%@",x);
    }];

}
//点击屏幕 触发事件 nameLabel 文本更改
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _nameText.backgroundColor = [UIColor yellowColor];
//
//}

-(void)ChannelSignal
{
    RACChannelTerminal *followT = RACChannelTo(_nameLabel,backgroundColor);
    [followT subscribeNext:^(id _Nullable x) {
        //每点击一次就输出一次随机颜色
        NSLog(@"%@",x);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        //改变nameLabel.backgroundColor
        [followT sendNext:[UIColor yellowColor]];
    }];
    [self.view addGestureRecognizer:tap];
    //将nameLabel.backgroundColor跟hightButton.backgroundColor绑定
    RACChannelTo(_hightButton,backgroundColor) = RACChannelTo(_nameLabel,backgroundColor);
}
-(void)define
{
    [RACObserve(self.view, backgroundColor) subscribeNext:^(id  _Nullable x) {
        //x==新背景颜色
        NSLog(@"%@",x);
    }];
    
   //将nameLabel.backgroundColor跟hightButton.backgroundColor绑定
   RACChannelTo(_hightButton,backgroundColor) = RACChannelTo(_nameLabel,backgroundColor);
    
   RACTuple *tuple = RACTuplePack(@1,@2,@"3");
    
    //传入需要解析生成的变量名，从第一个开始解析
    RACTupleUnpack(NSNumber *num1,NSNumber *num2) = tuple;
    //输出1，2
    NSLog(@"%@,%@",num1,num2);
    
}
@end
