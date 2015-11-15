//
//  LeavesViewController.h
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LeavesView;
// This view controller presents a LeavesView that occupies its entire view, and
// whose data source and delegate are the view controller itself.
//
// Subclasses should provide content by overriding the view controller's
// implementation of the LeavesViewDataSource protocol.
@interface LeavesViewController : UIViewController
{
    UIView* _topView;
}

// The LeavesView presented by the view controller.
@property (retain,nonatomic) LeavesView *leavesView;
//@property (retain, nonatomic) IBOutlet LeavesView *leavesView;

@end

