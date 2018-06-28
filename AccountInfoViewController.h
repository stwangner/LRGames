//
//  AccountInfoViewController.h
//  LRGames
//
//  Created by Stephen Wangner on 2/20/18.
//  Copyright © 2018 Stephen Wangner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoViewController : UIViewController
{
    NSURLProtectionSpace *myLoginProtectionSpace;
    NSString *myUserName;
    NSString *myPassword;
}

- (IBAction)SaveTap:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;

@end
