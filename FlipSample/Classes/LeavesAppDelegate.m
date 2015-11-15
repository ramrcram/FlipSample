//
//  LeavesAppDelegate.m
//  LeavesExamples
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesAppDelegate.h"
#import "ExamplesViewController.h"
#import "ImageExampleViewController.h"

@implementation LeavesAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//	UIViewController *rootViewController = [[[ExamplesViewController alloc] init] autorelease];
    UIViewController *rootViewController = [[[ImageExampleViewController alloc] init] autorelease];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
