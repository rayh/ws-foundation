
@interface NSDictionary (TypedAccess)

// Generic values
- (id)valueForKey:(id)key ifKindOf:(Class)aClass;
- (id)valueForKey:(id)key ifKindOf:(Class)aClass defaultValue:(id)defaultValue;
- (id)valueForKeyPath:(NSString *)path ifKindOf:(Class)aClass defaultValue:(id)defaultValue;

// String values
- (NSString *)stringValueForKeyPath:(NSString *)key defaultValue:(NSString*)defaultValue;
- (NSString *)stringValueForKeyPath:(NSString *)key;

// Array values
- (NSArray *)arrayValueForKeyPath:(NSString *)key;  // Defaults to nil
- (NSArray *)arrayValueForKeyPath:(NSString *)key defaultValue:(id)defaultValue;

// Dictionary values
- (NSDictionary *)dictionaryValueForKeyPath:(NSString *)key;

// URL
- (NSURL *)urlValueForKeyPath:(NSString*)key;

// Primitive Values
- (NSInteger)intValueForKeyPath:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (NSUInteger)unsignedIntValueForKeyPath:(NSString *)key defaultValue:(NSUInteger)defaultValue;
- (double)doubleValueForKeyPath:(NSString *)key defaultValue:(double)defaultValue;
- (double)floatValueForKeyPath:(NSString *)key defaultValue:(float)defaultValue;
- (BOOL)boolValueForKeyPath:(NSString *)key defaultValue:(BOOL)defaultValue;

- (NSInteger)intValueForKeyPath:(NSString *)key;
- (NSUInteger)unsignedIntValueForKeyPath:(NSString *)key;
- (double)doubleValueForKeyPath:(NSString *)key;
- (double)floatValueForKeyPath:(NSString *)key;
- (BOOL)boolValueForKeyPath:(NSString *)key;

@end
