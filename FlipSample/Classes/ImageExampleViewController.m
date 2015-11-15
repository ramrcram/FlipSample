    //
//  ExampleViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "ImageExampleViewController.h"
#import "Utilities.h"

@interface ImageExampleViewController ()

@property (readonly) NSArray *images;

@end

@implementation ImageExampleViewController

- (id)init {
    if (self = [super init]) {
		_images = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"01.jpg"],
                   [UIImage imageNamed:@"02.jpg"],
                   [UIImage imageNamed:@"03.jpg"],
                   [UIImage imageNamed:@"04.jpg"],
                   [UIImage imageNamed:@"05.jpg"],
                   [UIImage imageNamed:@"06.jpg"],
                   [UIImage imageNamed:@"07.jpg"],
                   [UIImage imageNamed:@"08.jpg"],
                   [UIImage imageNamed:@"09.jpg"],
                   [UIImage imageNamed:@"10.jpg"],
                   [UIImage imageNamed:@"11.jpg"],
                   [UIImage imageNamed:@"12.jpg"],
                   [UIImage imageNamed:@"13.jpg"],
                   [UIImage imageNamed:@"14.jpg"],
                   [UIImage imageNamed:@"15.jpg"],
                   nil];
    }
    return self;
}

- (void)dealloc {
	[_images release];
    [super dealloc];
}

#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return _images.count;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	UIImage *image = [_images objectAtIndex:index];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}

@end
