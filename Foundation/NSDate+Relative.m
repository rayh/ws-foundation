//
//  NSDate+Relative.m
//  CommunityRadio
//
//  Created by Ray Hilton on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Relative.h"

#define ONE_MINUTE              60
#define ONE_HOUR                3600
#define ONE_DAY                 86400
#define ONE_WEEK                604800
#define ONE_YEAR                31557600
#define ONE_MONTH               2629800

#define FORMAT_PAST_PATTERN     @"%0.0f %@ ago"
#define FORMAT_FUTURE_PATTERN   @"in %0.0f %@"

typedef enum {
    WSRelativeTimeIntervalNow,
    WSRelativeTimeIntervalOneMinute,
    WSRelativeTimeIntervalManyMinutes,
    WSRelativeTimeIntervalOneHour,
    WSRelativeTimeIntervalManyHours,
    WSRelativeTimeIntervalOneDay,
    WSRelativeTimeIntervalManyDays,
    WSRelativeTimeIntervalOneWeek,
    WSRelativeTimeIntervalManyWeeks,
    WSRelativeTimeIntervalOneMonth,
    WSRelativeTimeIntervalManyMonths,
    WSRelativeTimeIntervalOneYear,
    WSRelativeTimeIntervalManyYears,
    WSRelativeTimeIntervalDistant
} WSRelativeTimeInterval;

@implementation NSDate (Relative)

- (WSRelativeTimeInterval)relativeTimeInterval:(float)timeInterval
{
    timeInterval = fabsf(timeInterval);
    if(timeInterval>=ONE_YEAR*2)
        return WSRelativeTimeIntervalManyYears;
    else if(timeInterval>=ONE_YEAR)
        return WSRelativeTimeIntervalOneYear;
    else if(timeInterval>=ONE_MONTH*2)
        return WSRelativeTimeIntervalManyMonths;
    else if(timeInterval>=ONE_MONTH)
        return WSRelativeTimeIntervalOneMonth;
    else if(timeInterval>=ONE_WEEK*2)
        return WSRelativeTimeIntervalManyWeeks;
    else if(timeInterval>=ONE_WEEK)
        return WSRelativeTimeIntervalOneWeek;
    else if(timeInterval>=ONE_DAY*2)
        return WSRelativeTimeIntervalManyDays;
    else if(timeInterval>=ONE_DAY)
        return WSRelativeTimeIntervalOneDay;
    else if(timeInterval>=ONE_HOUR*2)
        return WSRelativeTimeIntervalManyHours;
    else if(timeInterval>=ONE_HOUR)
        return WSRelativeTimeIntervalOneHour;
    else if(timeInterval>=ONE_MINUTE*2)
        return WSRelativeTimeIntervalManyMinutes;
    else if(timeInterval>=ONE_MINUTE)
        return WSRelativeTimeIntervalOneMinute;
    else if(timeInterval>=0)
        return WSRelativeTimeIntervalNow;
    else
        return WSRelativeTimeIntervalDistant;
}

- (BOOL)isInTheFuture
{
    return [self timeIntervalSinceNow] > 0;
}


- (BOOL)isInThePast
{
    return [self timeIntervalSinceNow] <= 0;
}

- (NSString *)formatTimeInterval:(float)time unit:(NSString*)unit
{
    NSString *pattern = [self isInThePast] ? FORMAT_PAST_PATTERN : FORMAT_FUTURE_PATTERN;
//    NSLog(@"years: %d, months: %d, weeks: %d, hours: %d", ONE_YEAR, ONE_MONTH, ONE_WEEK, ONE_HOUR);
//    NSLog(@"I was passed a time of %0.4f and a unit of %@", time, unit);
    return [NSString stringWithFormat:pattern, time, unit];
}

- (NSString*)stringByFormattingAsRelativeTimestamp
{
    float timeInterval = fabsf([self timeIntervalSinceNow]);
//    NSLog(@"TIme interval is %0.4f (%0.4f) %d", timeInterval, timeInterval/ONE_HOUR, ONE_HOUR);
    switch([self relativeTimeInterval:timeInterval]) {
        case WSRelativeTimeIntervalNow:         return [self isInThePast] ? @"just now" : @"in a moment";
        case WSRelativeTimeIntervalOneMinute:   return [self isInThePast] ? @"a minute ago" : @"in a minute";
        case WSRelativeTimeIntervalOneHour:     return [self isInThePast] ? @"an hour ago" : @"in an hour";
        case WSRelativeTimeIntervalOneDay:      return [self isInThePast] ? @"a day ago" : @"in a day";
        case WSRelativeTimeIntervalOneWeek:     return [self isInThePast] ? @"a week ago" : @"in a day";
        case WSRelativeTimeIntervalOneMonth:    return [self isInThePast] ? @"a month ago" : @"in a month";
        case WSRelativeTimeIntervalOneYear:     return [self isInThePast] ? @"a year ago" : @"in a year";
        case WSRelativeTimeIntervalManyMinutes: return [self formatTimeInterval:timeInterval/ONE_MINUTE unit:@"minutes"];
        case WSRelativeTimeIntervalManyHours:   return [self formatTimeInterval:timeInterval/ONE_HOUR   unit:@"hours"];
        case WSRelativeTimeIntervalManyDays:    return [self formatTimeInterval:timeInterval/ONE_DAY    unit:@"days"];
        case WSRelativeTimeIntervalManyWeeks:   return [self formatTimeInterval:timeInterval/ONE_WEEK   unit:@"weeks"];
        case WSRelativeTimeIntervalManyMonths:  return [self formatTimeInterval:timeInterval/ONE_MONTH  unit:@"months"];
        case WSRelativeTimeIntervalManyYears:   return [self formatTimeInterval:timeInterval/ONE_YEAR   unit:@"years"];
        case WSRelativeTimeIntervalDistant: {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setTimeStyle:NSDateFormatterFullStyle];
            [df setFormatterBehavior:NSDateFormatterBehavior10_4];
            [df setDateFormat:@"EEE, d LLL yyyy HH:mm:ss"];
            return [df stringFromDate:self];
        }
    }
}

@end
