//
//  ViewController.m
//  WXQModel_Runtime
//
//  Created by WXQ on 2018/8/7.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Model.h"
#import "People.h"
#import "Lesson.h"
#import "School.h"
#import "Grade.h"

@interface ViewController ()
@property(nonatomic,copy)NSDictionary * dict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    People * p = [People ModelWithDict:self.dict];
    Lesson * l = [p.lessons lastObject];
    School * s = p.school;
    Grade * g = s.grade;
    NSLog(@"People:%@\n",p);
    NSLog(@"Lesson:%@\n",l);
    NSLog(@"School:%@\n",s);
    NSLog(@"Grade:%@\n",g);
    NSLog(@"teacher:%@",p.school.grade.teacher);
}

- (NSDictionary *)dict {
    if (!_dict) {
        _dict = @{
                  @"name" : @"Xiaoming",
                  @"age" : @18,
                  @"sex" : @"男",
                  @"city" : @"北京市",
                  @"lessons" : @[
                          @{
                              @"name" : @"语文",
                              @"score" : @125
                              },
                          @{
                              @"name" : @"数学",
                              @"score" : @146
                              },
                          @{
                              @"name" : @"英语",
                              @"score" : @112
                              }
                          ],
                  @"school" : @{
                          @"name" : @"海淀一中",
                          @"address" : @"海淀区",
                          @"grade" : @{
                                  @"name" : @"九年级",
                                  @"teacher" : @"Mr Li"
                                  }
                          }
                  };
    }
    return _dict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
