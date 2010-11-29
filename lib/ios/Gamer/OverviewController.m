//
//  OverviewController.m
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewController.h"
#import "OverviewController+TableView.h"
#import "GMRGlobals.h"
#import "GMRCreateGameController.h"
#import "GMRLabel.h"
#import "UIButton+GMRButtonTypes.h"
#import "GMRNoneView.h"

@implementation OverviewController
@synthesize matchesTable;

-(void)createGame
{
	GMRCreateGameController * controller = [[GMRCreateGameController alloc] initWithNibName:nil
																					 bundle:nil];
	
	UINavigationController * createGame      = [[UINavigationController alloc] initWithRootViewController:controller];
	createGame.navigationBar.tintColor       = [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1.0];
	
	[self presentModalViewController:createGame 
							animated:YES];
	[createGame release];
	[controller release];
}

- (void)noMatchesScheduled
{
	noneView = [[GMRNoneView alloc] initWithLabel:@"No Scheduled Games."];
	[self.view addSubview:noneView];
	[noneView release];
}

- (void)viewDidLoad 
{		
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Scheduled"];
	
	UIButton * addMatchButton = [UIButton buttonWithGMRButtonType:GMRButtonTypeAdd];
	[addMatchButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * addMatch = [[UIBarButtonItem alloc] initWithCustomView:addMatchButton];
	
	[self.navigationItem setRightBarButtonItem:addMatch animated:YES];
	[addMatch release];
	
	// cell height is set to 92 - Image components = 91 + 1 for seperator
	matchesTable.separatorColor = [UIColor blackColor];
	[self matchesTableRefresh];
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.matchesTable = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [matches release];
	[super dealloc];
}


@end
