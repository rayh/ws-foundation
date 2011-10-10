//
//  NSArray+TypedAccess.h
//  
//
//  Created by Ray Hilton on 29/08/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TypedAccess)
- (id)valueAtIndex:(NSUInteger)index ifKindOf:(Class)aClass;
- (id)valueAtIndex:(NSUInteger)index ifKindOf:(Class)aClass defaultValue:(id)defaultValue;
- (NSString *)stringValueAtIndex:(NSUInteger)index defaultValue:(NSString*)defaultValue;
- (NSString *)stringValueAtIndex:(NSUInteger)index;
- (NSArray *)arrayValueAtIndex:(NSUInteger)index;
- (NSDictionary *)dictionaryValueAtIndex:(NSUInteger)index;
- (NSURL *)urlValueAtIndex:(NSUInteger)index; 
- (NSInteger)intValueAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;
- (NSUInteger)unsignedIntValueAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue;
- (double)doubleValueAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;
- (double)floatValueAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;
- (BOOL)boolValueAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;
- (NSInteger)intValueAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntValueAtIndex:(NSUInteger)index;
- (double)doubleValueAtIndex:(NSUInteger)index;
- (double)floatValueAtIndex:(NSUInteger)index;
- (BOOL)boolValueAtIndex:(NSUInteger)index;
@end
