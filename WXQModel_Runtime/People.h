//
//  People.h
//  WXQModel_Runtime
//
//  Created by WXQ on 2018/8/7.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+Model.h"
#import "School.h"

@interface People : BaseModel
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)int age;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,strong)School * school;
@property(nonatomic,strong)NSArray * lessons;
@end
