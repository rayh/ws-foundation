//
//  NSArray+TypesAccess.m
//  
//
//  Created by Ray Hilton on 29/08/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSArray+TypedAccess.h"

@implementation NSArray (TypedAccess)

- (id)valueAtIndex:(NSUInteger)index ifKindOf:(Class)aClass {
    return [self valueAtIndex:index ifKindOf:aClass defaultValue:nil];
}

- (id)valueAtIndex:(NSUInteger)index ifKindOf:(Class)aClass defaultValue:(id)defaultValue {
    id value = [self objectAtIndex:index];
    return [value isKindOfClass:aClass] ? value : defaultValue;
}

- (NSString *)stringValueAtIndex:(NSUInteger)index defaultValue:(NSString*)defaultValue {
    return [self valueAtIndex:index ifKindOf:[NSString class] defaultValue:defaultValue];
}

- (NSString *)stringValueAtIndex:(NSUInteger)index {
    return [self stringValueAtIndex:index defaultValue:@""];
}

- (NSArray *)arrayValueAtIndex:(NSUInteger)index{
    return [self valueAtIndex:index ifKindOf:[NSArray class] defaultValue:@[]];
}

- (NSDictionary *)dictionaryValueAtIndex:(NSUInteger)index {
    return [self valueAtIndex:index ifKindOf:[NSDictionary class] defaultValue:@{}];;
}

- (NSURL *)urlValueAtIndex:(NSUInteger)index 
{
    NSString *stringValue = [self stringValueAtIndex:index defaultValue:nil];
    return stringValue==nil ? nil : [NSURL URLWithString:stringValue];
}

- (NSInteger)intValueAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue {
    return [[self valueAtIndex:index ifKindOf:[NSNumber class] defaultValue:@(defaultValue)] intValue];
}

- (NSUInteger)unsignedIntValueAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue {
    return [[self valueAtIndex:index ifKindOf:[NSNumber class] defaultValue:@(defaultValue)] unsignedIntValue];
}

- (double)doubleValueAtIndex:(NSUInteger)index defaultValue:(double)defaultValue {
    return [[self valueAtIndex:index ifKindOf:[NSNumber class] defaultValue:@(defaultValue)] doubleValue];
}

- (double)floatValueAtIndex:(NSUInteger)index defaultValue:(float)defaultValue {
    return [[self valueAtIndex:index ifKindOf:[NSNumber class] defaultValue:@(defaultValue)] floatValue];
}

- (BOOL)boolValueAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue {
    return [[self valueAtIndex:index ifKindOf:[NSNumber class] defaultValue:@(defaultValue)] boolValue];
}

- (NSInteger)intValueAtIndex:(NSUInteger)index {
    return [self intValueAtIndex:index defaultValue:0];
}

- (NSUInteger)unsignedIntValueAtIndex:(NSUInteger)index {
    return [self unsignedIntValueAtIndex:index defaultValue:0];
}

- (double)doubleValueAtIndex:(NSUInteger)index {
    return [self doubleValueAtIndex:index defaultValue:0];
}

- (double)floatValueAtIndex:(NSUInteger)index {
    return [self floatValueAtIndex:index defaultValue:0];
}

- (BOOL)boolValueAtIndex:(NSUInteger)index {
    return [self boolValueAtIndex:index defaultValue:FALSE];
}

@end
