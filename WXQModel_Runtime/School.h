//
//  School.h
//  WXQModel_Runtime
//
//  Created by WXQ on 2018/8/7.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "BaseModel.h"
#import "Grade.h"

@interface School : BaseModel
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * address;
@property(nonatomic,strong)Grade * grade;
@end
