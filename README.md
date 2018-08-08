# WXQModel_Runtime
Runtime实现iOS字典转模型

字典转模型核心代码：
```
#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)

+ (instancetype)ModelWithDict:(NSDictionary *)dict {
    NSObject * obj = [[self alloc]init];
    [obj transformDict:dict];
    return obj;
}

- (void)transformDict:(NSDictionary *)dict {
    Class cla = self.class;
    // count:成员变量个数
    unsigned int outCount = 0;
    // 获取成员变量数组
    Ivar *ivars = class_copyIvarList(cla, &outCount);
    // 遍历所有成员变量
    for (int i = 0; i < outCount; i++) {
        // 获取成员变量
        Ivar ivar = ivars[i];
        // 获取成员变量名字
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 成员变量名转为属性名（去掉下划线 _ ）
        key = [key substringFromIndex:1];
        // 取出字典的值
        id value = dict[key];
        // 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil而报错
        if (value == nil) continue;
        // 获得成员变量的类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 如果属性是对象类型（字典或者数组中包含字典）
        NSRange range = [type rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            // 那么截取对象的名字（比如@"School"，截取为School）
            type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
            // 排除系统的对象类型(如果人为的设置自定义的类带@”NS“如：NSSchool,则会出现错误)
            if (![type hasPrefix:@"NS"]) {//字典
                // 将对象名转换为对象的类型，将新的对象字典转模型（递归）,如Grade，并将其对象grade对应的字典转换成模型
                Class class = NSClassFromString(type);
                value = [class ModelWithDict:value];
            }else if ([type isEqualToString:@"NSArray"]) {//数组中包含字典
                // 如果是数组类型，将数组中的每个模型进行字典转模型，先创建一个临时数组存放模型
                NSArray *array = (NSArray *)value;
                NSMutableArray *mArray = [NSMutableArray array];
                // 获取到每个模型的类型
                id class ;
                if ([self respondsToSelector:@selector(gainClassType)]) {
                    //获取数组中每个字典对应转换的类型，即重写gainClassType方法返回的类型：Lesson
                    NSString *classStr = [self gainClassType];
                    class = NSClassFromString(classStr);
                }
                // 将数组中的所有模型进行字典转模型
                for (int i = 0; i < array.count; i++) {
                    [mArray addObject:[class ModelWithDict:value[i]]];
                }
                value = mArray;
            }
        }
        // 利用KVC将字典中的值设置到模型上
        [self setValue:value forKeyPath:key];
    }
    //需要释放指针，因为ARC不适用C函数
    free(ivars);
}

@end
```

重写description方法核心代码：
```
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
```
