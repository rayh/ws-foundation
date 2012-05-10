
#import "NSDictionary+TypedAccess.h"
#import "NSDateFormatter+ISO8601.h"

@implementation NSDictionary (TypedAccess)

- (id)valueForKey:(id)key ifKindOf:(Class)aClass {
    return [self valueForKey:key ifKindOf:aClass defaultValue:nil];
}

- (id)valueForKey:(id)key ifKindOf:(Class)aClass defaultValue:(id)defaultValue {
    id value = [self objectForKey:key];
    return [value isKindOfClass:aClass] ? value : defaultValue;
}

- (id)valueForKeyPath:(NSString *)path ifKindOf:(Class)aClass defaultValue:(id)defaultValue {
    id value = [self valueForKeyPath:path];
    return [value isKindOfClass:aClass] ? value : defaultValue;
}


- (NSString *)stringValueForKeyPath:(NSString *)key defaultValue:(NSString*)defaultValue {
    return [self valueForKeyPath:key ifKindOf:[NSString class] defaultValue:defaultValue];
}

- (NSString *)stringValueForKeyPath:(NSString *)key {
    return [self stringValueForKeyPath:key defaultValue:@""];
}

- (NSArray *)arrayValueForKeyPath:(NSString *)key defaultValue:(id)defaultValue {
    return [self valueForKeyPath:key ifKindOf:[NSArray class] defaultValue:defaultValue];
}

- (NSArray *)arrayValueForKeyPath:(NSString *)key{
    return [self arrayValueForKeyPath:key defaultValue:nil];
}

- (NSDictionary *)dictionaryValueForKeyPath:(NSString *)key defaultValue:(id)defaultValue {
    return [self valueForKeyPath:key ifKindOf:[NSDictionary class] defaultValue:defaultValue];;
}

- (NSDictionary *)dictionaryValueForKeyPath:(NSString *)key {
    return [self dictionaryValueForKeyPath:key defaultValue:[NSDictionary dictionary]];
}

- (NSURL *)urlValueForKeyPath:(NSString *)key 
{
    NSString *stringValue = [self stringValueForKeyPath:key defaultValue:nil];
    return stringValue==nil ? nil : [NSURL URLWithString:stringValue];
}

- (NSInteger)intValueForKeyPath:(NSString *)key defaultValue:(NSInteger)defaultValue {
    return [[self valueForKeyPath:key ifKindOf:[NSNumber class] defaultValue:[NSNumber numberWithInt:defaultValue]] intValue];
}

- (NSUInteger)unsignedIntValueForKeyPath:(NSString *)key defaultValue:(NSUInteger)defaultValue {
    return [[self valueForKeyPath:key ifKindOf:[NSNumber class] defaultValue:[NSNumber numberWithUnsignedInt:defaultValue]] unsignedIntValue];
}

- (double)doubleValueForKeyPath:(NSString *)key defaultValue:(double)defaultValue {
    return [[self valueForKeyPath:key ifKindOf:[NSNumber class] defaultValue:[NSNumber numberWithDouble:defaultValue]] doubleValue];
}

- (double)floatValueForKeyPath:(NSString *)key defaultValue:(float)defaultValue {
    return [[self valueForKeyPath:key ifKindOf:[NSNumber class] defaultValue:[NSNumber numberWithFloat:defaultValue]] floatValue];
}

- (BOOL)boolValueForKeyPath:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [[self valueForKeyPath:key ifKindOf:[NSNumber class] defaultValue:[NSNumber numberWithBool:defaultValue]] boolValue];
}

- (NSInteger)intValueForKeyPath:(NSString *)key {
    return [self intValueForKeyPath:key defaultValue:0];
}

- (NSUInteger)unsignedIntValueForKeyPath:(NSString *)key {
    return [self unsignedIntValueForKeyPath:key defaultValue:0];
}

- (double)doubleValueForKeyPath:(NSString *)key {
    return [self doubleValueForKeyPath:key defaultValue:0];
}

- (double)floatValueForKeyPath:(NSString *)key {
    return [self floatValueForKeyPath:key defaultValue:0];
}

- (BOOL)boolValueForKeyPath:(NSString *)key {
    return [self boolValueForKeyPath:key defaultValue:FALSE];
}

- (NSDate*)dateValueForISO8601StringKeyPath:(NSString*)key 
{
    return [self dateValueForISO8601StringKeyPath:key defaultValue:nil];
}

- (NSDate*)dateValueForISO8601StringKeyPath:(NSString*)key defaultValue:(id)defaultValue
{
    NSString *stringValue = [self stringValueForKeyPath:key defaultValue:nil];
    return stringValue==nil ? defaultValue : [[NSDateFormatter iso8601DateFormatter] dateFromString:stringValue];
}

@end

