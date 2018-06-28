//
//  ViewControllerAddGiftCard.h
//  LRGames
//
//  Created by Stephen Wangner on 10/2/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>

@interface ViewControllerAddGiftCard : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scanbutton;
@property (weak, nonatomic) IBOutlet UITextField *gctextfield;
@property (weak, nonatomic) IBOutlet UIView *scanview;
@property (weak, nonatomic) IBOutlet UIButton *savebutton;


- (IBAction)startStopReading:(id)sender;
- (IBAction)savebuttonpressed:(id)sender;
- (IBAction)cancelbuttonpressed:(id)sender;

@end
