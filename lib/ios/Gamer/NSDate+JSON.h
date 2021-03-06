//
//  NSDateFormatter+JSON.h
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(JSON) 

+ (NSDate *)dateWithJSONString:(NSString *)string;
+ (NSString *)dateToJSONString:(NSDate *)date;
+ (NSString *)gamerScheduleTimeString:(NSDate *)scheduled_time;
+ (NSString *)relativeTime:(NSDate *)date;

@end
