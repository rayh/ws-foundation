#import "NSArray+Collections.h"


@implementation NSArray (NSArray_Collections)
-(NSArray *) each: (void(^)(id object))block {
	for ( id item in self )
	{
		block(item);
	}
	return self;
}

-(NSArray *) map: (id(^)(id object))block {
	NSMutableArray *result = [NSMutableArray array];
	[self each:^(id object) { [result addObject:block(object)]; }];
	return [NSArray arrayWithArray:result];
}

-(NSArray *) select: (BOOL(^)(id object))block {
	NSMutableArray *result = [NSMutableArray array];
	[self each:^(id object) {
		if(block(object)){
			[result addObject:object];
		};
	}];
	return [NSArray arrayWithArray:result];
}

-(NSString *) join {
	return [self join:@""];
}

-(NSString *) join:(NSString *)separator {
	return [self componentsJoinedByString:separator];
}

-(NSArray *) filter: (BOOL(^)(id object))block {
	return [self select:block];
}

-(NSArray *) sort: (NSComparisonResult(^)(id obj1, id obj2))block {
	return [self sortedArrayUsingComparator:block];
}

-(id) first {
    if([self count]==0)
        return nil;
    
	return [self objectAtIndex:0];
}

-(id) last {
	return [self lastObject];
}

-(NSArray *) take: (int)numberToTake {
	NSMutableArray *result = [NSMutableArray array];
	for ( int i = 0; i < [self count]; i++ )
	{
		if (i < numberToTake) {
			[result addObject:[self objectAtIndex:i]];
		}
		
	}
	return [NSArray arrayWithArray:result];
}

-(NSArray *) step: (int)numberToStep {
	NSMutableArray *result = [NSMutableArray array];
	for ( int i = numberToStep; i < [self count]; i++ )
	{
		[result addObject:[self objectAtIndex:i]];
	}
	return [NSArray arrayWithArray:result];
}

-(BOOL) all: (BOOL(^)(id obj1))block {
	BOOL result = YES;
	for(id object in self){
		result = result && block(object);
	}
	return result;
}

-(BOOL) none: (BOOL(^)(id obj1))block {
	for(id object in self){
		if(block(object)){
			return NO;
		}
	}
	return YES;
}

-(BOOL) any: (BOOL(^)(id obj1))block {
	for(id object in self){
		if(block(object)){
			return YES;
		}
	}
	return NO;
}


-(id) reduce:(id(^)(id value, id object))block initial:(id)initial {
	id result = initial;
	for(id object in self){
		result = block(result, object);
	}
	return result;
}

-(id) detect:(BOOL (^)(id))block {
    for(id object in self){
        if(block(object)){
            return object;
        }
    }
    return nil;
}

-(id) first:(BOOL (^)(id))block {
    return [self detect:block];
}

-(NSDictionary *) partition:(id(^)(id))block{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(id item in self) {
        id key = block(item);
        NSMutableArray *objects = [result objectForKey:key];
        if(objects == nil){
            objects = [NSMutableArray array];
        }
        [objects addObject:item];
        [result setObject:objects forKey:key];
    }
    return result;
}

- (id)random
{
    if([self count]==0) {
        return nil;
    } else {
        NSUInteger randomIndex = arc4random() % [self count];
        return [self objectAtIndex:randomIndex];
    }
}

@end
