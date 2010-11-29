//
//  OverviewController.h
//  Gamer
//
//  Created by Adam Venturella on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRViewController.h"
@interface OverviewController : GMRViewController {
	UITableView * matchesTable;
	NSMutableArray * matches;
	UIView * noneView;
}
@property(nonatomic, retain)IBOutlet UITableView * matchesTable;

- (void)createGame;
- (void)noMatchesScheduled;
@end
