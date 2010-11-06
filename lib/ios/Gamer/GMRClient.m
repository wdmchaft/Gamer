//
//  GMRClient.m
//  Gamer
//
//  Created by Adam Venturella on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRClient.h"
#import "GMRTypes.h"
#import "GMRRequest.h"

static NSArray * platformStrings;

@implementation GMRClient
@synthesize username;
@dynamic apiKey;

+(void)initialize
{
	platformStrings = [NSArray arrayWithObjects:@"xbox360", 
					                            @"wii",
					                            @"playstation3",
					                            @"playstation2",
					                            @"pc",
												nil];
	[platformStrings retain];
}

- (id)init
{
	self = [super init];
	
	if(self)
	{
		apiRequest = [[GMRRequest alloc] init];
	}
	
	return self;
}

- (GMRClient *)initWithKey:(NSString *)key andName:(NSString *)name
{
	self = [self init];
	
	if(self)
	{
		apiRequest.key = key;
		username = [name copy];
	}
	
	return self;
}


- (NSString *)apiKey
{
	return apiRequest.key;
}

- (void)setApiKey:(NSString *)value
{
	apiRequest.key = value;
}


- (NSString *)stringForPlatform:(GMRPlatform)platform
{
	return [platformStrings objectAtIndex:platform];
}

- (void)authenticateUser:(NSString *)name password:(NSString *)password withCallback:(GMRCallback)callback
{
	NSString*      method = @"POST";
	NSString*      path   = @"http://hazgame.com/accounts/login";
	NSDictionary * data   = [NSDictionary dictionaryWithObjectsAndKeys:name, @"username", password, @"password", nil];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", data, @"data", nil]
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)version:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = @"/system/version";
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
}


- (void)searchPlatform:(GMRPlatform)platform forGame:(NSString *)query withCallback:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = [NSString stringWithFormat:@"/games/%@/search/%@", [self stringForPlatform:platform], query];
	
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)gamesForPlatform:(GMRPlatform)platform withCallback:(GMRCallback)callback
{
	NSString*     method = @"GET";
	NSString*     path   = [NSString stringWithFormat:@"/games/%@", [self stringForPlatform:platform]];
	NSDictionary* query  = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"limit", nil];
	
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", query, @"query", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
}

- (void)matchCreate:(NSDate *)scheduledTime gameId:(NSString *)gameId platform:(GMRPlatform)platform availability:(GMRMatchAvailablilty)availability maxPlayers:(NSUInteger)maxPlayers invitedPlayers:(NSArray *)invitedPlayers label:(NSString *)label withCallback:(GMRCallback)callback
{
	NSString * time;
	NSString * availabilityString  = (availability == GMRMatchAvailabliltyPublic) ? @"public" : @"private";
	NSLocale * enUSPOSIXLocale     = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSTimeZone * utc               = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	// JSON format: 2010-11-06T18:18:19.658Z we are leaving off fractions of a second
	// if you need it the format would be:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
	dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    [dateFormatter setTimeZone:utc];
	[dateFormatter setLocale:enUSPOSIXLocale];
	
	
    time = [dateFormatter stringFromDate:scheduledTime];
    
	[dateFormatter release];
	
	NSString*     method = @"POST";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@", [self stringForPlatform:platform], gameId];
	
	// send urlencoded array for invitedPlayers as "players"
	NSDictionary* data   = [NSDictionary dictionaryWithObjectsAndKeys:
							time,                                          @"scheduled_time",
							availabilityString,                            @"availability", 
							[NSString stringWithFormat:@"%u", maxPlayers], @"maxPlayers",
							label,                                         @"label", 
							invitedPlayers,                                @"players", nil];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", data, @"data", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
}

- (void)matchJoin:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback
{
	NSString*     method = @"POST";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@/%@/%@", [self stringForPlatform:platform],
							gameId,
							matchId,
							username];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)matchLeave:(GMRPlatform)platform gameId:(NSString *)gameId matchId:(NSString *)matchId withCallback:(GMRCallback)callback
{
	NSString*     method = @"DELETE";
	NSString*     path   = [NSString stringWithFormat:@"/matches/%@/%@/%@/%@", [self stringForPlatform:platform],
							gameId,
							matchId,
							username];
	
	[apiRequest execute:[NSDictionary dictionaryWithObjectsAndKeys:method, @"method", path, @"path", nil] 
		   withCallback:^(BOOL ok, NSDictionary * response){
			   callback(ok, response);
		   }];
	
}

- (void)dealloc
{
	self.username = nil;
	
	[apiRequest release];
	apiRequest = nil;
	
	[super dealloc];
}



@end