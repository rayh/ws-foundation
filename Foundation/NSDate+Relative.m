//
//  NSDate+Relative.m
//  CommunityRadio
//
//  Created by Ray Hilton on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Relative.h"

#define ONE_MINUTE              60
#define ONE_HOUR                ONE_MINUTE*60
#define ONE_DAY                 ONE_HOUR*24
#define ONE_WEEK                ONE_DAY*7
#define ONE_YEAR                ONE_DAY*365
#define ONE_MONTH               ONE_YEAR/12

#define FORMAT_PAST_PATTERN     @"%d %@ ago"
#define FORMAT_FUTURE_PATTERN   @"in %d %@"

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

- (WSRelativeTimeInterval)relativeTimeIntervalSinceNow
{
    NSTimeInterval timeInterval = fabsf([self timeIntervalSinceNow]);
    
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

- (NSString*)stringByFormattingAsRelativeTimestamp
{
    NSTimeInterval timeInterval = fabsf([self timeIntervalSinceNow]);
    NSString *pattern = [self isInThePast] ? FORMAT_PAST_PATTERN : FORMAT_FUTURE_PATTERN;
    switch([self relativeTimeIntervalSinceNow]) {
        case WSRelativeTimeIntervalNow:         return [self isInThePast] ? @"just now" : @"in a moment";
        case WSRelativeTimeIntervalOneMinute:   return [self isInThePast] ? @"a minute ago" : @"in a minute";
        case WSRelativeTimeIntervalOneHour:     return [self isInThePast] ? @"an hour ago" : @"in an hour";
        case WSRelativeTimeIntervalOneDay:      return [self isInThePast] ? @"a day ago" : @"in a day";
        case WSRelativeTimeIntervalOneWeek:     return [self isInThePast] ? @"a week ago" : @"in a day";
        case WSRelativeTimeIntervalOneMonth:    return [self isInThePast] ? @"a month ago" : @"in a month";
        case WSRelativeTimeIntervalOneYear:     return [self isInThePast] ? @"a year ago" : @"in a year";
        case WSRelativeTimeIntervalManyMinutes: return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_MINUTE), @"minutes"];
        case WSRelativeTimeIntervalManyHours:   return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_HOUR), @"hours"];
        case WSRelativeTimeIntervalManyDays:    return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_DAY), @"days"];
        case WSRelativeTimeIntervalManyWeeks:   return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_WEEK), @"weeks"];
        case WSRelativeTimeIntervalManyMonths:  return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_MONTH), @"months"];
        case WSRelativeTimeIntervalManyYears:   return [NSString stringWithFormat:pattern, (int)(timeInterval/ONE_YEAR), @"years"];
        case WSRelativeTimeIntervalDistant: {
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setTimeStyle:NSDateFormatterFullStyle];
            [df setFormatterBehavior:NSDateFormatterBehavior10_4];
            [df setDateFormat:@"EEE, d LLL yyyy HH:mm:ss"];
            return [df stringFromDate:self];
        }
    }
}

@end
