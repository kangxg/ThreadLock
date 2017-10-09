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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self runCoordinator];
   // [self runCounting];
    [self createUser];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
