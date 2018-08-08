//
//  BaseModel.m
//  WXQModel_Runtime
//
//  Created by WXQ on 2018/8/7.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "BaseModel.h"
#import <objc/message.h>

@implementation BaseModel

- (NSString *)description {
    unsigned int count;
    const char *clasName = object_getClassName(self);
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%s: %p>:[ \n",clasName, self];
    Class clas = NSClassFromString([NSString stringWithCString:clasName encoding:NSUTF8StringEncoding]);
    Ivar *ivars = class_copyIvarList(clas, &count);
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            //得到类型
            NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:key];
            //确保BOOL 值输出的是YES 或 NO，这里的B是我打印属性类型得到的……
            if ([type isEqualToString:@"B"]) {
                value = (value == 0 ? @"NO" : @"YES");
            }
            [string appendFormat:@"\t%@ = %@\n",[self delLine:key], value];
        }
    }
    [string appendFormat:@"]"];
    return string;
}

//去掉下划线
- (NSString *)delLine:(NSString *)string {
    
    if ([string hasPrefix:@"_"]) {
        return [string substringFromIndex:1];
    }
    return string;
}

@end
