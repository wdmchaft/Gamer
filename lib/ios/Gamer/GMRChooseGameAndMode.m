//
//  GMRChooseGameAndMode.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseGameAndMode.h"
#import "GMRChooseGameAndMode+TableView.h"
#import "GMRChooseGameAndMode+SearchTableView.h"
#import "GMRNavigationController.h"
#import "GMRGame.h"
#import "GMRMatch.h"
#import "GMRCreateGameGlobals.h"
#import "GMRLabel.h"

@implementation GMRChooseGameAndMode
@synthesize gameLabel, modeLabel, modesView, modesTableView;

- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Game and Mode"];
	
	for(UIView * targetView in [self.navigationController.view subviews])
	{
		if([targetView class]== [UIImageView class])
		{
			navigationBarShadow = (UIImageView *)targetView;
		}
	}
	
	
	if(kCreateMatchProgress.game)	
	{
		gameLabel.text = kCreateMatchProgress.game.label;
		modesView.hidden = NO;
		
		if(kCreateMatchProgress.game.selectedMode > -1)
		{
			modeLabel.text          = [kCreateMatchProgress.game.modes objectAtIndex:kCreateMatchProgress.game.selectedMode];
			NSUInteger indexes[]    = {0, kCreateMatchProgress.game.selectedMode};
			
			NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
			[modesTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
		}
	}
	
	[kCreateMatchProgress addObserver:self 
						   forKeyPath:@"game" 
							  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
							  context:nil];
	
	[super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// If the game changed we need to reset the mode.
	// Also when the game changes a whole new GMRGame object is used
	// so selectedMode will always be -1
	
	modeLabel.text  = @"Mode";
	[modesTableView deselectRowAtIndexPath:[modesTableView indexPathForSelectedRow]
								animated:NO];
		
	
	if([kCreateMatchProgress.game.modes count] > 0)
	{
		
		[modesTableView reloadData];
		// showing modes view for the first time.
		if(modesView.hidden)
		{
			modesView.transform = CGAffineTransformMakeTranslation(0.0, 187.0);
			modesView.hidden = NO;
			[UIView animateWithDuration:0.3 
								  delay:0.25 
								options:UIViewAnimationCurveEaseOut 
							 animations:^{
								 modesView.transform = CGAffineTransformIdentity;
							 } 
							 completion:NULL];
		}
		
		if([kCreateMatchProgress.game.modes count] < 4)
		{
			modesTableView.scrollEnabled = NO;
		}
	}
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.gameLabel = nil;
	self.modeLabel = nil;
	self.modesView = nil;
	self.modesTableView = nil;
}


- (void)dealloc 
{
    [kCreateMatchProgress removeObserver:self 
							  forKeyPath:@"game"];
	[games release];
	[super dealloc];
}


@end
