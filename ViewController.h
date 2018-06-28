//
//  ViewController.h
//  LRGames
//
//  Created by Stephen Wangner on 9/29/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSURLProtectionSpace *myLoginProtectionSpace;
    NSInteger lastWebCall;
    
    IBOutlet UIWebView *myWebView;
}

- (IBAction)giftcardbuttontouchdown:(id)sender;
- (IBAction)eventsclicked:(id)sender;
- (IBAction)dealsclicked:(id)sender;
- (IBAction)newsclicked:(id)sender;
- (IBAction)dcountclicked:(id)sender;

@end
