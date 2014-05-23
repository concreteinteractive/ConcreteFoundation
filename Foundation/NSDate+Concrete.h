//
//  NSDate+Concrete.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 8/8/13.
//  Copyright (c) 2013 Concrete Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CITimeUnitSecond = 0,
    CITimeUnitMinute = 60,
    CITimeUnitHour   = 3600,
    CITimeUnitDay    = 86400,
    CITimeUnitWeek   = 604800,
    CITimeUnitMonth  = 2628000,
    CITimeUnitYear   = 31536000
} CITimeUnit;

@interface NSDate (Concrete)

+ (NSString *)shortStringForTimeInterval:(NSTimeInterval)interval;
+ (NSString *)shortStringForTimeInterval:(NSTimeInterval)interval withMaxTimeBlock:(CITimeUnit)maxTimeBlock;
+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval;
+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval withMaxTimeBlock:(CITimeUnit)maxTimeBlock;

- (NSString *)stringWithFormat:(NSString *)format;

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;

+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger) dDays;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) dDays;
+ (NSDate *)dateWithHoursFromNow:(NSInteger) dHours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger) dHours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger) dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger) dMinutes;

#pragma mark - Comparing dates
- (BOOL)isEqualToDateIgnoringTime:(NSDate *) otherDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isSameWeekAsDate:(NSDate *) aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameMonthAsDate:(NSDate *) aDate;
- (BOOL)isThisMonth;
- (BOOL)isSameYearAsDate:(NSDate *) aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate:(NSDate *) aDate;
- (BOOL)isLaterThanDate:(NSDate *) aDate;
- (BOOL)isEarlierThanOrEqualDate:(NSDate *) aDate;
- (BOOL)isLaterThanOrEqualDate:(NSDate *) aDate;
- (BOOL)isInPast;
- (BOOL)isInFuture;


#pragma mark - Date roles
- (BOOL)isWeekday;
- (BOOL)isWeekend;

#pragma mark - Adjusting dates
- (NSDate *)dateByAddingYears:(NSInteger) dYears;
- (NSDate *)dateBySubtractingYears:(NSInteger) dYears;
- (NSDate *)dateByAddingMonths:(NSInteger) dMonths;
- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths;
- (NSDate *)dateByAddingWeeks:(NSInteger) dWeeks;
- (NSDate *)dateBySubtractingWeeks:(NSInteger) dWeeks;
- (NSDate *)dateByAddingDays:(NSInteger) dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger) dDays;
- (NSDate *)dateByAddingHours:(NSInteger) dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger) dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger) dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger) dMinutes;
- (NSDate *)dateAtStartOfDay;
- (NSDate *)dateAtEndOfDay;
- (NSDate *)dateAtStartOfMonth;
- (NSDate *)dateAtEndOfMonth;
- (NSDate *)dateAtStartOfYear;
- (NSDate *)dateAtEndOfYear;


#pragma mark - Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *) aDate;
- (NSInteger)minutesBeforeDate:(NSDate *) aDate;
- (NSInteger)hoursAfterDate:(NSDate *) aDate;
- (NSInteger)hoursBeforeDate:(NSDate *) aDate;
- (NSInteger)daysAfterDate:(NSDate *) aDate;
- (NSInteger)daysBeforeDate:(NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *) aDate;

#pragma mark - Decomposing dates
// NSDate-Utilities API is broken?
- (NSInteger)nearestHour;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)week;
- (NSInteger)weekday;
- (NSInteger)firstDayOfWeek;
- (NSInteger)lastDayOfWeek;
- (NSInteger)nthWeekdayOfTheMonth;
- (NSInteger)year;

@end
