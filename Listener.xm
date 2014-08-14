#import "libactivator.h"
@class SBMediaController;
@interface Lullaby : NSObject<LAListener, UIAlertViewDelegate> 
{} 
-(void)stopMusic;
@end

UITextField* minutesField;
NSString* minutes = @"";

@implementation Lullaby

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	UIAlertView* askAlert = [[UIAlertView alloc] initWithTitle:@"Lullaby" message:@"Enter the number of minutes until your music should stop playing" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
	[askAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
	minutesField = [askAlert textFieldAtIndex:0];
	//[askAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
	minutesField.autocorrectionType = UITextAutocorrectionTypeNo;
	minutesField.enablesReturnKeyAutomatically = YES;
	[minutesField setPlaceholder:@"15 minutes"];
	[askAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		minutes = @"";
		NSString* result = @"";
		minutes = (NSString*)minutesField.text;
		//for (NSString* inChar in minutes) {
		for (int i = 0; i < [minutes length]; i++) {
			NSString* inChar = [minutes substringWithRange:NSMakeRange(i, 1)];
			if ([inChar isEqualToString:@"0"] || [inChar isEqualToString:@"1"] || [inChar isEqualToString:@"2"] || [inChar isEqualToString:@"3"] || [inChar isEqualToString:@"4"] || [inChar isEqualToString:@"5"] || [inChar isEqualToString:@"6"] || [inChar isEqualToString:@"7"] || [inChar isEqualToString:@"8"] || [inChar isEqualToString:@"9"]) {
				result = [result stringByAppendingString:inChar];
			}
			else {
			}
		}
		if (result == nil || [result isEqualToString:@""]) {
			UIAlertView* badInputAlert = [[UIAlertView alloc] initWithTitle:@"Lullaby" message:@"Please enter a valid number of minutes." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[badInputAlert show];
		}
		else {
			int fadeTime = [result intValue] * 60;
			NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:fadeTime target:self selector:@selector(stopMusic) userInfo:nil repeats:NO];
		}
	}
}

-(void)stopMusic {
	[[%c(SBMediaController) sharedInstance] pause];
}

+(void)load {
	if ([LASharedActivator isRunningInsideSpringBoard]) {
		[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.phillip.lullaby"];
	}
}

@end
