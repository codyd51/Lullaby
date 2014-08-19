#import "libactivator.h"
@class SBMediaController;
@interface Lullaby : NSObject<LAListener, UIAlertViewDelegate> {
@private 
UIAlertView *av;

} 
@end

@implementation Lullaby

- (BOOL)dismiss {
	// Ensures alert view is dismissed
	// Returns YES if alert was visible previously
	if (av) {
		[av dismissWithClickedButtonIndex:[av cancelButtonIndex] animated:YES];
		[av release];
		av = nil;
		return YES;
	}
	return NO;
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	[self dismiss];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	[self dismiss];
}


- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	if ([self dismiss])
		[event setHandled:YES];
}


-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if (![self dismiss]) { 
	  av = [[UIAlertView alloc] initWithTitle:@"Lullaby" message:@"Enter the number of minutes until your music should stop playing" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
	[av setAlertViewStyle:UIAlertViewStylePlainTextInput];
	UITextField *avField = [av textFieldAtIndex:0];
	[avField setKeyboardType:UIKeyboardTypeNumberPad];
	avField.autocorrectionType = UITextAutocorrectionTypeNo;
	avField.enablesReturnKeyAutomatically = YES;
	[avField setPlaceholder:@"15"];
	[av show];

      }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[av release];
	av = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex]) {
	  return;      
	}

       int minutes = [[alertView textFieldAtIndex:0].text intValue];

       dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC * (minutes * 60)),dispatch_get_main_queue(), ^{
	   [((SBMediaController *)[%c(SBMediaController) sharedInstance]) pause];
       });
}

-(void)dealloc {

[av release];
[super dealloc];

}

+(void)load {
	if ([LASharedActivator isRunningInsideSpringBoard]) {
		[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.phillip.lullaby"];
	}
}

@end
