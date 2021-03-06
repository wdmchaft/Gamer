//
//  GMRAuthenticationNewAccount.h
//  Gamer
//
//  Created by Adam Venturella on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMRAuthenticationInputController;
@interface GMRAuthenticationNewAccount : UIViewController<UITextFieldDelegate>
{
	GMRAuthenticationInputController * inputController;
	UITextField * email;
	UITextField * username;
	UITextField * password;
	UITextField * passwordConfirm;
}

@property(nonatomic, assign) GMRAuthenticationInputController * inputController;
@property(nonatomic, retain) IBOutlet UITextField * email;
@property(nonatomic, retain) IBOutlet UITextField * username;
@property(nonatomic, retain) IBOutlet UITextField * password;
@property(nonatomic, retain) IBOutlet UITextField * passwordConfirm;

- (void)cancel;
- (void)create;
- (void)createFailedWithErrors:(NSArray *)errors;
- (void)createSucceeded;

- (void)transitionOut;
@end
