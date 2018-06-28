//
//  AccountInfoViewController.m
//  LRGames
//
//  Created by Stephen Wangner on 2/20/18.
//  Copyright © 2018 Stephen Wangner. All rights reserved.
//

#import "AccountInfoViewController.h"

@interface AccountInfoViewController ()

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set up Login Protection Space
    NSURL *url = [NSURL URLWithString:@"http://www.legendaryrealmsgames.com"];
    myLoginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                      port:[url.port integerValue]
                                                                  protocol:url.scheme
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
    
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    //Retrieve credential from storage (keychain)
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:myLoginProtectionSpace];
    credential = [credentials.objectEnumerator nextObject];
    
    //Populate the text fields with data from the credential
    _UserNameTextField.text = credential.user;
    _PasswordTextField.text = credential.password;
    
    //Store credential - only necessary for the first run of the view
    credential = [NSURLCredential credentialWithUser:_UserNameTextField.text password:_PasswordTextField.text persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:myLoginProtectionSpace];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveTap:(id)sender {
    //Set up Login Protection Space
    NSURL *url = [NSURL URLWithString:@"http://www.legendaryrealmsgames.com"];
    myLoginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                   port:[url.port integerValue]
                                                               protocol:url.scheme
                                                                  realm:nil
                                                   authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
    
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    //Remove existing credential
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:myLoginProtectionSpace];
    credential = [credentials.objectEnumerator nextObject];
    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:myLoginProtectionSpace];
    
    //Store new credential using data from text fields
    credential = [NSURLCredential credentialWithUser:_UserNameTextField.text password:_PasswordTextField.text persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:myLoginProtectionSpace];
    
    //go back to main screen
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
