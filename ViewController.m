//
//  ViewController.m
//  LRGames
//
//  Created by Stephen Wangner on 9/29/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self handleWebViewLoad:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //If the last web call was to User Menu, reload it.  Credentials may have changed.
    if (lastWebCall == 3) {
        [self handleWebViewLoad:3];
    }
}

- (void)handleWebViewLoad:(int)newvalue {
    Reachability *internetReachability;
    
    internetReachability = [Reachability reachabilityForInternetConnection];
        
    if (internetReachability.currentReachabilityStatus == NotReachable) {
        [myWebView loadHTMLString:@"Network connection unavailable.  Please try again later." baseURL:[NSURL URLWithString:@""]];
    } else {
        [myWebView loadHTMLString:@"<html><head></head><body>Loading...</body></html>"  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
            
        NSString *dataUrl;
            
        if (newvalue == 0) {
            //Set up base URL
            dataUrl = @"http://www.legendaryrealmsgames.com/mobileappresponder.php?requesttype=events";
        }
            
        if (newvalue == 1) {
            //Set up base URL
            dataUrl = @"http://www.legendaryrealmsgames.com/mobileappresponder.php?requesttype=deals";
        }
            
        if (newvalue == 2) {
            //Set up base URL
            dataUrl = @"http://www.legendaryrealmsgames.com/mobileappresponder.php?requesttype=news";
        }
        
        if (newvalue == 3) {
            //Get phone name
            NSString *phoneName = [[UIDevice currentDevice] name];
            
            //Set allowed characters
            NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
            
            //Set up Login Protection Space
            NSURL *url = [NSURL URLWithString:@"http://www.legendaryrealmsgames.com"];
            myLoginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                           port:[url.port integerValue]
                                                                       protocol:url.scheme
                                                                          realm:nil
                                                           authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
            
            NSURLCredential *credential;
            NSDictionary *credentials;
            
            //Get credential from storage (keychain)
            credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:myLoginProtectionSpace];
            credential = [credentials.objectEnumerator nextObject];
            
            //Set up base URL
            dataUrl = @"http://www.legendaryrealmsgames.com/members/mobileuserfunctions.php?phonename=";
            
            //Add phone name to querystring
            NSString *percentEncodedString = [phoneName stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            dataUrl = [dataUrl stringByAppendingString:percentEncodedString];
            
            //Add username from credential to querystring
            dataUrl = [dataUrl stringByAppendingString:@"&username="];
            percentEncodedString = [credential.user stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            dataUrl = [dataUrl stringByAppendingString:percentEncodedString];
            
            //Add password from credential to querystring
            dataUrl = [dataUrl stringByAppendingString:@"&password="];
            percentEncodedString = [credential.password stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            dataUrl = [dataUrl stringByAppendingString:percentEncodedString];
        }
        
        NSURL *url = [NSURL URLWithString:dataUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [myWebView loadRequest:requestObj];
    }
}


- (IBAction)giftcardbuttontouchdown:(id)sender {
    [self performSegueWithIdentifier:@"ToGiftCards" sender:self];
}

- (IBAction)eventsclicked:(id)sender {
    [self handleWebViewLoad:0];
    lastWebCall = 0;
}

- (IBAction)dealsclicked:(id)sender {
    [self handleWebViewLoad:1];
    lastWebCall = 1;
}

- (IBAction)newsclicked:(id)sender {
    [self handleWebViewLoad:2];
    lastWebCall = 2;
}

- (IBAction)dcountclicked:(id)sender {
    [self handleWebViewLoad:3];
    lastWebCall = 3;
}

@end
