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

@property (nonatomic)      RACDelegateProxy   *  proxy;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self runCoordinator];
   // [self runCounting];
    //[self createUser];
    [self createUI];
    [self demoKvo];
    [self textFileCombination];
    [self buttonDemo];
    [self delegateDemo];
    [self notificationDemo];
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
    [self.view addSubview:self.nameText];
    [self.view addSubview:self.passWordText];
    [self.view addSubview:self.loginButton];
    
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
//点击屏幕 触发事件 nameLabel 文本更改
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.person.name = [NSString stringWithFormat:@"kang %d",arc4random_uniform(100)];
    [self.nameText resignFirstResponder];
    
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

@end
