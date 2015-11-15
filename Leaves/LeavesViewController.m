//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"
#import "LeavesView.h"
#import "PDFExampleViewController.h"
#import "ImageExampleViewController.h"
#import "UIColor+colorWithHexString.h"

#define xPadding 10
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESSER_THAN_OR_EQUAL_TO(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface LeavesViewController () <LeavesViewDataSource, LeavesViewDelegate>

@end

@implementation LeavesViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        _leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
        _leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _leavesView.dataSource = self;
        _leavesView.delegate = self;
    }
    return self;
}

- (void)dealloc {
	[_leavesView release];
    [super dealloc];
}

#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return 0;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    UISegmentedControl* sg = [self addTopView];
    [self.view addSubview:sg];
    
    [self addController:sg.frame];
    
    sg = nil;
}

#pragma mark Methods

-(void)addController:(CGRect)segmentFrame{
    
    if([self.view viewWithTag:1010])
    {
        [[self.view viewWithTag:1010] removeFromSuperview];
    }
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGRect frameView = self.view.frame;
    frameView.origin.x = xPadding;
    frameView.origin.y = segmentFrame.origin.y + segmentFrame.size.height + xPadding;
    frameView.size.width = frameView.size.width - (xPadding  * 2);
    frameView.size.height = (frameView.size.height - (segmentFrame.origin.y + segmentFrame.size.height + navFrame.size.height)) - xPadding;
    _leavesView.frame = frameView;
    _leavesView.tag = 1010;
    _leavesView.backgroundColor =  [UIColor colorWithHexStr:@"cdcdcd"];
    [self.view addSubview:_leavesView];
    [_leavesView reloadData];
}

-(void)shareIt:(id)sender{
    UIImage* imgShare = [_leavesView getCurrentImage];
    if(imgShare != nil)
    {
        
        NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com"]];
        
        NSArray *activityItems = @[imgShare, shareURL];
        NSArray *excludeActivities = @[UIActivityTypePrint,UIActivityTypeMessage,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeMessage,UIActivityTypeMail];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:activityItems applicationActivities:nil];
        
        activityController.excludedActivityTypes = excludeActivities;
        
        [activityController setCompletionHandler:^(NSString *activityType, BOOL completed) {
            if(completed)
            {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"Share Success!"
                                           delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil] show];
            }
        }];
        
        // switch for iPhone and iPad.
        if (IS_IPAD) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                               ^{
                                   [popover presentPopoverFromRect:((UIButton*)sender).frame
                                                            inView:_topView
                                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                                          animated:YES];
                               });
                
            }
            else{
                [self presentViewController:activityController animated:YES completion:nil];
            }
        } else {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
                UIPopoverPresentationController *presentationController = [activityController popoverPresentationController];
                presentationController.sourceView = sender;
                [self presentViewController:activityController animated:YES completion:nil];
            }else{
                
                [self presentViewController:activityController animated:YES completion:^{
                    
                }];}
        }
        
    }
}

#pragma mark SegmentController

-(void)SegmentControlAction:(id)sender{
 
    UIViewController *viewController;
    
    UISegmentedControl* sg = (UISegmentedControl*)(sender);
    
    switch (sg.selectedSegmentIndex) {
        case 0:
            viewController = [[[PDFExampleViewController alloc] init] autorelease];
            _leavesView = (LeavesView*)viewController.view;
            [self addController:sg.frame];
            break;
        case 1:
            viewController = [[[ImageExampleViewController alloc] init] autorelease];
            _leavesView = (LeavesView*)viewController.view;
            [self addController:sg.frame];
            break;
        default:
            viewController = nil;
    }
}

-(UISegmentedControl*)addSegmentController{
    @autoreleasepool {
        CGRect navFrame = self.navigationController.navigationBar.frame;
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"PDF", @"IMAGE",nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame = CGRectMake(xPadding,
                                            navFrame.origin.y + navFrame.size.height + xPadding  ,
                                            self.view.frame.size.width - (xPadding * 2),
                                            44);
        [segmentedControl addTarget:self action:@selector(SegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 0;
        return segmentedControl;
    }
}

-(UIView*)addTopView{

    @autoreleasepool {

        CGRect navFrame = self.navigationController.navigationBar.frame;
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(xPadding,
                                            navFrame.origin.y + navFrame.size.height + xPadding  ,
                                            self.view.frame.size.width - (xPadding * 2),
                                            32);
        [_topView setBackgroundColor:[UIColor colorWithHexStr:@"eaeaea"]];
        
        UIButton* btnShare = [[UIButton alloc] init];
        btnShare.frame = CGRectMake(10, 0, 32, 32);
        [btnShare setImage:[UIImage imageNamed:@"icon-share.png"] forState:UIControlStateNormal];
        btnShare.contentMode = UIViewContentModeScaleAspectFit;
        [btnShare addTarget:self action:@selector(shareIt:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:btnShare];
        
        return _topView;
    }
}

@end
