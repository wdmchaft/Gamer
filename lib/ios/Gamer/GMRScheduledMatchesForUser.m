//
//  GMRScheduledMatchesForuser.m
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRScheduledMatchesForUser.h"
#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"

@implementation GMRScheduledMatchesForUser

- (void)refresh:(UIView *)target;
{
	UITableView * tableView = (UITableView *)target;
	
	[kGamerApi matchesScheduled:^(BOOL ok, NSDictionary * response)
	 {
		 if(ok)
		 {
			 matches = (NSArray *)[response objectForKey:@"matches"];
			 [matches retain];
			 dispatch_async(dispatch_get_main_queue(), ^{[tableView reloadData];});
		 }
	 }];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [matches count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary * item = [matches objectAtIndex:indexPath.row];
	
	NSString * scheduled_time = [item objectForKey:@"scheduled_time"];
	NSDate * date = [NSDate dateWithJSONString:scheduled_time];
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	// TODO: nned to let the user configure how they want their time.
	[formatter setDateFormat:@"EEE, LLL dd hh:mm a"];
	NSString * displayDate = [formatter stringFromDate:date];
	[formatter release];
	
	
	
	cell.textLabel.text = (NSString *)[item objectForKey:@"label"];
	cell.detailTextLabel.text = displayDate;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


@end