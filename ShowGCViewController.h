//
//  ShowGCViewController.h
//  LRGames
//
//  Created by Stephen Wangner on 10/2/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "qrencode.h"

@interface ShowGCViewController : UIViewController {
    NSString *myString2;
    Boolean downloadfinished;
    int xxx;
}

@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UILabel *GCCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *GCBalanceLabel;
@property (strong) NSManagedObject *giftcard;

@end
