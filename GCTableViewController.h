//
//  GCTableViewController.h
//  LRGames
//
//  Created by Stephen Wangner on 10/2/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShowGCViewController.h"

@interface GCTableViewController : UITableViewController {
    NSIndexPath *rowindexselected;
}

- (IBAction)donebuttonpressed:(id)sender;
- (IBAction)addbuttonpress:(id)sender;

@end
