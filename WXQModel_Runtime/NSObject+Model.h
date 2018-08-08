//
//  NSObject+Model.h
//  WXQModel_Runtime
//
//  Created by WXQ on 2018/8/7.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

+ (instancetype)ModelWithDict:(NSDictionary *)dict;
- (void)transformDict:(NSDictionary *)dict;
//获取数组中模型对象的类型
- (NSString *)gainClassType;

@end
