//
//  NSDate+Concrete.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import "NSDate+Concrete.h"

#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define HOURS_IN_DAY 24

@implementation NSDate (Concrete)

#pragma mark - Time Interval Strings

+ (NSString *)shortStringForTimeInterval:(NSTimeInterval)interval
{
    return [NSDate shortStringForTimeInterval:interval withMaxTimeBlock:CITimeUnitWeek];
}

+ (NSString *)shortStringForTimeInterval:(NSTimeInterval)interval withMaxTimeBlock:(CITimeUnit)maxTimeBlock
{
    NSString* result = nil;
    if (abs(interval) < CITimeUnitMinute || maxTimeBlock == CITimeUnitSecond)
    {
        result = [NSString stringWithFormat:@"%ds", abs(interval)];
    } else if (abs(interval) < CITimeUnitHour || maxTimeBlock == CITimeUnitMinute)
    {
        result = [NSString stringWithFormat:@"%dm", abs(interval/CITimeUnitMinute)];
    } else if (abs(interval) < CITimeUnitDay || maxTimeBlock == CITimeUnitHour)
    {
        result = [NSString stringWithFormat:@"%dh", abs(interval/CITimeUnitHour)];
    } else if (abs(interval) < CITimeUnitWeek || maxTimeBlock == CITimeUnitDay)
    {
        result = [NSString stringWithFormat:@"%dd", abs(interval/CITimeUnitDay)];
    } else if (abs(interval) < CITimeUnitMonth || maxTimeBlock == CITimeUnitWeek)
    {
        result = [NSString stringWithFormat:@"%dw", abs(interval/CITimeUnitWeek)];
    } else if (abs(interval) < CITimeUnitYear || maxTimeBlock == CITimeUnitMonth)
    {
        result = [NSString stringWithFormat:@"%dM", abs(interval/CITimeUnitMonth)];
    } else
    {
        result = [NSString stringWithFormat:@"%dy", abs(interval/CITimeUnitYear)];
    }
    if (interval < 0) {
        result = [@"-" stringByAppendingString:result];
    }
    return result;
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval
{
    return [NSDate stringForTimeInterval:interval withMaxTimeBlock:CITimeUnitWeek];
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval withMaxTimeBlock:(CITimeUnit)maxTimeBlock
{
    int number = 0;
    NSString* result = nil;
    if (abs(interval) < CITimeUnitMinute || maxTimeBlock == CITimeUnitSecond)
    {
        number = abs(interval);
        result = [NSString stringWithFormat:@"%d second", number];
    } else if (abs(interval) < CITimeUnitHour || maxTimeBlock == CITimeUnitMinute)
    {
        number = abs(interval/CITimeUnitMinute);
        result = [NSString stringWithFormat:@"%d minute", number];
    } else if (abs(interval) < CITimeUnitDay || maxTimeBlock == CITimeUnitHour)
    {
        number = abs(interval/CITimeUnitHour);
        result = [NSString stringWithFormat:@"%d hour", number];
    } else if (abs(interval) < CITimeUnitWeek || maxTimeBlock == CITimeUnitDay)
    {
        number = abs(interval/CITimeUnitDay);
        result = [NSString stringWithFormat:@"%d day", number];
    } else if (abs(interval) < CITimeUnitMonth || maxTimeBlock == CITimeUnitWeek)
    {
        number = abs(interval/CITimeUnitWeek);
        result = [NSString stringWithFormat:@"%d week", number];
    } else if (abs(interval) < CITimeUnitYear || maxTimeBlock == CITimeUnitMonth)
    {
        number = abs(interval/CITimeUnitMonth);
        result = [NSString stringWithFormat:@"%d month", number];
    } else
    {
        number = abs(interval/CITimeUnitYear);
        result = [NSString stringWithFormat:@"%d year", number];
    }
    if (number != 1) {
        result = [result stringByAppendingString:@"s"];
    }
    if (interval < 0) {
        result = [@"-" stringByAppendingString:result];
    }
    return result;
}

- (NSString *)stringWithFormat:(NSString *)format
{
    if (format == nil)
    {
        format = ISO_8601;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format
{
    if (format == nil)
    {
        format = ISO_8601;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - Relative dates from the current date
+ (NSDate *)dateTomorrow {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (CITimeUnitDay * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateYesterday {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (CITimeUnitDay * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (CITimeUnitDay * dDays);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (CITimeUnitDay * dDays);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (CITimeUnitHour * dHours);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (CITimeUnitHour * dHours);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (CITimeUnitMinute * dMinutes);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (CITimeUnitMinute * dMinutes);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

#pragma mark - Comparing dates
- (BOOL)isEqualToDateIgnoringTime:(NSDate *) otherDate {
    NSCalendar *currentCalendar = [NSDate currentCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *componentsSelf = [currentCalendar components:unitFlags fromDate:self];
    NSDateComponents *componentsArgs = [currentCalendar components:unitFlags fromDate:otherDate];
    return (componentsSelf.year == componentsArgs.year) &&
    (componentsSelf.month == componentsArgs.month) &&
    (componentsSelf.day == componentsArgs.day);
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameWeekAsDate:(NSDate *) aDate {
    NSDate* dateAtBeginningOfWeek = [[self dateBySubtractingDays:[self weekday] - 1] dateAtStartOfDay];
    NSDate* dateAtEndOfWeek = [[self dateByAddingDays:7 - [self weekday]] dateAtEndOfDay];
    return [aDate isLaterThanOrEqualDate:dateAtBeginningOfWeek] && [aDate isEarlierThanOrEqualDate:dateAtEndOfWeek];
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek {
    NSDate *nextWeek = [NSDate dateWithDaysFromNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:nextWeek];
}

- (BOOL)isLastWeek {
    NSDate *lastWeek = [NSDate dateWithDaysBeforeNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:lastWeek];
}

- (BOOL)isSameMonthAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return (componentsSelf.year == componentsArgs.year && componentsSelf.month == componentsArgs.month);
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSYearCalendarUnit fromDate:aDate];
    return (componentsSelf.year == componentsArgs.year);
}

- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *componentsNextYear = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    componentsNextYear.year += 1;
    return (componentsSelf.year == componentsNextYear.year);
}

- (BOOL)isLastYear {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *componentsLastYear = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    componentsLastYear.year -= 1;
    return (componentsSelf.year == componentsLastYear.year);
}

- (BOOL)isEarlierThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isEarlierThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedAscending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isLaterThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedDescending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isInPast {
    return [self isEarlierThanDate:[NSDate date]];
}

- (BOOL)isInFuture {
    return [self isLaterThanDate:[NSDate date]];
}


#pragma mark - Date roles
- (BOOL)isWeekday {
    return ([self isWeekend] == NO);
}

- (BOOL)isWeekend {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSInteger weekdayOfDate = [components weekday];
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
        return YES;
    }
    return NO;
}

#pragma mark - Adjusting dates
- (NSDate *)dateByAddingYears:(NSInteger) dYears {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = dYears;
    NSCalendar *calendar = [NSDate currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingYears:(NSInteger) dYears {
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger) dMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = dMonths;
    NSCalendar *calendar = [NSDate currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths {
    return [self dateByAddingMonths:-dMonths];
}

- (NSDate *)dateByAddingWeeks:(NSInteger) dWeeks {
    return [self dateByAddingTimeInterval:(CITimeUnitMonth * dWeeks)];
}

- (NSDate *)dateBySubtractingWeeks:(NSInteger) dWeeks {
    return [self dateByAddingTimeInterval:-(CITimeUnitMonth * dWeeks)];
}

- (NSDate *)dateByAddingDays:(NSInteger) dDays {
    return [self dateByAddingTimeInterval:(CITimeUnitDay * dDays)];
}

- (NSDate *)dateBySubtractingDays:(NSInteger) dDays {
    return [self dateByAddingTimeInterval:-(CITimeUnitDay * dDays)];
}

- (NSDate *)dateByAddingHours:(NSInteger) dHours {
    return [self dateByAddingTimeInterval:(CITimeUnitHour * dHours)];
}

- (NSDate *)dateBySubtractingHours:(NSInteger) dHours {
    return [self dateByAddingTimeInterval:-(CITimeUnitHour * dHours)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger) dMinutes {
    return [self dateByAddingTimeInterval:(CITimeUnitMinute * dMinutes)];
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger) dMinutes {
    return [self dateByAddingTimeInterval:-(CITimeUnitMinute * dMinutes)];
}

- (NSDate *)dateAtStartOfDay {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfMonth {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    components.day = range.location;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfMonth {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    components.day = range.length;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfYear {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    components.day = dayRange.location;
    components.month = monthRange.location;
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return startOfYear;
}

- (NSDate *)dateAtEndOfYear {
    NSCalendar *calendar = [NSDate currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    components.day = dayRange.length;
    components.month = monthRange.length;
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return endOfYear;
}


#pragma mark - Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *) aDate {
    return (NSInteger)([self timeIntervalSinceDate:aDate] / CITimeUnitMinute);
}

- (NSInteger)minutesBeforeDate:(NSDate *) aDate {
    return (NSInteger)([aDate timeIntervalSinceDate:self] / CITimeUnitMinute);
}

- (NSInteger)hoursAfterDate:(NSDate *) aDate {
    return (NSInteger)([self timeIntervalSinceDate:aDate] / CITimeUnitHour);
}

- (NSInteger)hoursBeforeDate:(NSDate *) aDate {
    return (NSInteger)([aDate timeIntervalSinceDate:self] / CITimeUnitHour);
}

- (NSInteger)daysAfterDate:(NSDate *) aDate {
    return (NSInteger)([self timeIntervalSinceDate:aDate] / CITimeUnitDay);
}

- (NSInteger)daysBeforeDate:(NSDate *) aDate {
    return (NSInteger)([aDate timeIntervalSinceDate:self] / CITimeUnitDay);
}

- (NSInteger)distanceInDaysToDate:(NSDate *) aDate {
    NSDateComponents *dateComponents = [[NSDate currentCalendar]
                                        components:NSDayCalendarUnit fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}

#pragma mark - Decomposing dates
- (NSInteger)nearestHour {
    if (self.minute < 30) {
        return self.hour;
    } else {
        return [[self dateByAddingHours:1] hour];
    }
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}

- (NSInteger)second {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSSecondCalendarUnit fromDate:self];
    return [components second];
}

- (NSInteger)day {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSInteger)month {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSInteger)week {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSWeekCalendarUnit fromDate:self];
    return [components week];
}

- (NSInteger)weekday {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    return [components weekday];
}

- (NSInteger)firstDayOfWeek {
    return [[self dateBySubtractingDays:[self weekday] - 1] day];
}

- (NSInteger)lastDayOfWeek {
    return [[self dateByAddingDays:7 - [self weekday]] day];
}

- (NSInteger)nthWeekdayOfTheMonth {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSWeekdayOrdinalCalendarUnit fromDate:self];
    return [components weekdayOrdinal];
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

#pragma mark - Thread specific cached calendar

+ (NSCalendar *)currentCalendar
{
    NSCalendar *currentCalendar = [[[NSThread currentThread] threadDictionary] objectForKey:@"currentCalendar"];
    if (currentCalendar == nil) {
        currentCalendar = [NSCalendar currentCalendar];
        [[[NSThread currentThread] threadDictionary] setObject:currentCalendar forKey:@"currentCalendar"];
    }
    return currentCalendar;
}

@end
