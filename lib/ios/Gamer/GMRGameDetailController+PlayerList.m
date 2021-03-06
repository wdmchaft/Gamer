//
//  GMRGameDetailController+PlayerList.m
//  Gamer
//
//  Created by Adam Venturella on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRGameDetailController+PlayerList.h"

#import "GMRGlobals.h"
#import "GMRClient.h"
#import "NSDate+JSON.h"
#import "GMRPlayerListCell.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRPlayer.h"


enum {
	PlayerListCellStylePlayer,
	PlayerListCellStyleOpen
};
typedef NSUInteger PlayerListCellStyle;


@implementation GMRGameDetailController(PlayerList)

- (void)playersTableRefresh
{	
	GMRPlatform platform    = match.platform;
	//NSString * game = [[match.game.id componentsSeparatedByString:@"/"] objectAtIndex:1];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	if(platform != GMRPlatformUnknown)
	{
		//NSLog(@"Match Id: %@", match.id);
		[kGamerApi playersForMatch:platform 
							gameId:match.game.id 
						   matchId:match.id 
						  callback:^(BOOL ok, NSDictionary * response)
		 {
			 /* response :
			  ok = 1;
			  players = (
				{
					alias = logix812;
					username = aventurella;
				}
			  );
			  */
			 
			 if(ok)
			 {
				 
				 dispatch_async(dispatch_get_main_queue(), ^{
					 NSInteger count = [[response objectForKey:@"players"] count];
					 GMRPlayer * players[count];
					 NSArray * responseCollection = (NSArray *)[response objectForKey:@"players"];
					 
					 for(NSInteger i =0; i < count; i++)
					 {
						 GMRPlayer * p = [GMRPlayer playerWithDicitonary:[responseCollection objectAtIndex:i]];
						 players[i] = p;
					 }
					 
					 self.playersForMatch = [NSArray arrayWithObjects:players count:count];
					 
					 
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					 [playersTableView reloadData];
					 
					 if(membership == GMRMatchMembershipUnknown)
						 [self setupToolbar];
				 });
			 }
			 else 
			 {
				 dispatch_async(dispatch_get_main_queue(), ^{
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				 });
			 }

		 }];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger count = 0;
	
	if(self.playersForMatch != nil)
	{
		count = MAX(match.maxPlayers, 4);
		
		if(count == 4)
			tableView.scrollEnabled = NO;
	}
	
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier         = @"PlayerListCell";
	static NSString *CellIdentifierCreator  = @"PlayerListCellCreator";
	static NSString *CellIdentifierOpen     = @"PlayerListCellOpen";
	NSString * alias                        = @"-- Open --";
	
	PlayerListCellStyle cellStyle = indexPath.row > ([self.playersForMatch count] -1 ) ? PlayerListCellStyleOpen : PlayerListCellStylePlayer;
	
	if(cellStyle == PlayerListCellStyleOpen && (indexPath.row + 1) > match.maxPlayers)
	{
		alias = @"-- Closed --";
	}
	
	NSString * reusableId;
	
	NSString * username;
	
	if(cellStyle == PlayerListCellStylePlayer)
	{
		
		GMRPlayer * player = (GMRPlayer *)[self.playersForMatch objectAtIndex:indexPath.row];
		
		alias      = player.alias;
		username   = player.username;		
		
		reusableId = [username isEqualToString:match.created_by]? CellIdentifierCreator : CellIdentifier;
	}
	else 
	{
		reusableId = cellStyle == PlayerListCellStyleOpen ? CellIdentifierOpen : CellIdentifier;
	}

	
	GMRPlayerListCell *cell = (GMRPlayerListCell *)[tableView dequeueReusableCellWithIdentifier:reusableId];
    
	if (cell == nil) 
	{
		cell = [[[GMRPlayerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableId] autorelease];
    }
    
	if(cellStyle == PlayerListCellStylePlayer)
	{
		cell.player = alias;
	}
	else 
	{
		cell.player = alias;
	}

	
	//cell.player = [[self.playersForMatch objectAtIndex:indexPath.row] objectForKey:@"alias"];
	//NSLog(@"%@", cell.player);
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"This row!");
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
