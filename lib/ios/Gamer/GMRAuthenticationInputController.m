//
//  GMRAuthenticationInputController.m
//  Gamer
//
//  Created by Adam Venturella on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <dispatch/dispatch.h>
#import "GMRAuthenticationInputController.h"
#import "GMRAuthenticationController.h"
#import "GMRAuthenticationNewAccount.h"
#import "GMRGlobals.h"
#import "GMRClient.h"

@implementation GMRAuthenticationInputController
@synthesize username, password, authenticationController;

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)newAccount
{
	newAccountController = [[GMRAuthenticationNewAccount alloc] initWithNibName:nil bundle:nil];
	newAccountController.view.frame = CGRectMake(self.view.frame.size.width, 0.0, self.view.frame.size.width, self.view.frame.size.height);	
	
	
	[newAccountController viewWillAppear:YES];
	
	
	[UIView transitionWithView:self.view.superview
					  duration:0.35f 
					   options:UIViewAnimationOptionCurveEaseInOut  
					animations:^{
						[self.view.superview addSubview:newAccountController.view];
						self.view.superview.transform = CGAffineTransformMakeTranslation(-1 * self.view.frame.size.width, 0.0);
						//self.view.superview.frame = CGRectMake(-1 * self.view.frame.size.width, 0.0, self.view.superview.frame.size.width, self.view.superview.frame.size.height);
					} 
					completion:^(BOOL finished){
						[newAccountController viewDidAppear:YES];
						newAccountController.inputController = self;
						self.view.superview.frame = CGRectMake(self.view.superview.frame.origin.x, 0.0, (self.view.superview.frame.size.width * 2), self.view.superview.frame.size.height);
					}];
}

- (IBAction)authenticate
{
	NSString * usernameString = self.username.text;
	NSString * passwordString = self.password.text;
	
	// both of these methods will be invoked from a background thread
	[kGamerApi authenticateUser:usernameString password:passwordString withCallback:^(BOOL ok, NSDictionary * response){
		if(YES)
		{
			NSString * token = (NSString *)[response objectForKey:@"token"];
			kGamerApi.username = usernameString;
			kGamerApi.apiKey   = token;
			[self authenticationDidSucceedWithUsername:usernameString andToken:token];
		}
		else 
		{
			[self authenticationDidFail];
		}

	}];
}

- (void)authenticationDidSucceedWithUsername:(NSString *)name andToken:(NSString *)token;
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:name forKey:@"username"];
	[defaults setObject:token forKey:@"token"];
	
	// because this will affect the ui thread (the transition), 
	// we need to be sure it's called from the main thread	
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.authenticationController authenticationDidSucceed];
	});
	
	
	//SEL command = @selector(authenticationDidSucceed);
	//NSInvocation* invocation     = [NSInvocation invocationWithMethodSignature:[self.parentViewController methodSignatureForSelector:command]];
	//[invocation setTarget:self.parentViewController];
	//[invocation setSelector:command];
	
	//[invocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:NO];	
}

- (void)authenticationDidFail
{
	NSLog(@"Authentication failed!");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == self.username)
	{
		[self.password becomeFirstResponder];
		
	}
	else 
	{
		[self.username becomeFirstResponder];
	}
	
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.username becomeFirstResponder];
	
	if(newAccountController)
	{
		[newAccountController.view removeFromSuperview];
		[newAccountController release];
		newAccountController = nil;
	}
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.username = nil;
	self.password = nil;
	self.authenticationController = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
