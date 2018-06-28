//
//  ShowGCViewController.m
//  LRGames
//
//  Created by Stephen Wangner on 10/2/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import "ShowGCViewController.h"
#import "Reachability.h"

@interface ShowGCViewController ()

@property (strong) NSMutableArray *giftcards;

@end

@implementation ShowGCViewController

@synthesize giftcard;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.giftcard) {
        NSString *cardcode = [self.giftcard valueForKey:@"cardcode"];
        NSString *cardbalance;
        
        NSString *displaycode = @"";
        
        NSRange xRange;
        
        xRange = NSMakeRange(0, 4);
        displaycode = [displaycode stringByAppendingString:[cardcode substringWithRange:xRange]];
        displaycode = [displaycode stringByAppendingString:@" "];
        
        xRange = NSMakeRange(4, 4);
        displaycode = [displaycode stringByAppendingString:[cardcode substringWithRange:xRange]];
        displaycode = [displaycode stringByAppendingString:@" "];
        
        xRange = NSMakeRange(8, 4);
        displaycode = [displaycode stringByAppendingString:[cardcode substringWithRange:xRange]];
        displaycode = [displaycode stringByAppendingString:@" "];
        
        xRange = NSMakeRange(12, 4);
        displaycode = [displaycode stringByAppendingString:[cardcode substringWithRange:xRange]];
        
        [self.GCCodeLabel setText:displaycode];
        
        NSString *str = @"shopify-giftcard-v1-";
        str = [str stringByAppendingString:[self.giftcard valueForKey:@"cardcode"]];
        
        UIImage *image = [self quickResponseImageForString:str withDimension:182];
        
        [_QRImageView setImage: image];
        
        Reachability *internetReachability;
        internetReachability = [Reachability reachabilityForInternetConnection];
        
        if (internetReachability.currentReachabilityStatus == NotReachable) {
            cardbalance = @"Card balance currently unavailable";
        } else {
            myString2 = @"";
            
            NSString *dataUrl;
            dataUrl = @"http://www.legendaryrealmsgames.com/mobileappresponder.php?requesttype=gcardbal&ccode=";
            dataUrl = [dataUrl stringByAppendingString:cardcode];
            
            NSURL *url = [NSURL URLWithString:dataUrl];
            
            // 2
            NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                                  dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      
                                                      if (error) {
                                                          //error condition handler
                                                          
                                                          downloadfinished = true;
                                                          
                                                          myString2 = @"Card balance currently unavailable";
                                                      } else {
                                                      
                                                          // 4: Handle response here
                                                      
                                                          NSString *myString;
                                                          myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                      
                                                      
                                                          myString2 = myString;
                                                      
                                                          downloadfinished = true;
                                                      }
                                                  }];
            
            [downloadTask resume];
            
            do {
                xxx = 0;
            } while (downloadfinished == false);
            
            cardbalance = [@"Balance: " stringByAppendingString:myString2];
            
            if ([myString2 isEqual:@"0.00\n\n"]) {
                NSString *alerttext = @"This Gift Card has a zero balance.  Would you like to remove it?";
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:alerttext
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
                //Create an action
                UIAlertAction *yesdelete = [UIAlertAction actionWithTitle:@"Yes"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             [self deleteGiftCard];
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                         }];
                UIAlertAction *nocancel = [UIAlertAction actionWithTitle:@"No"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action)
                                               {
                                                   
                                               }];
                //Add action to alertCtrl
                [alert addAction:yesdelete];
                [alert addAction:nocancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            if ([myString2 isEqual:@"\n\n"]) {
                NSString *alerttext = @"This is not a valid Gift Card.  Would you like to remove it?";
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:alerttext
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                //Create an action
                UIAlertAction *yesdelete = [UIAlertAction actionWithTitle:@"Yes"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action)
                                            {
                                                [self deleteGiftCard];
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }];
                UIAlertAction *nocancel = [UIAlertAction actionWithTitle:@"No"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
                //Add action to alertCtrl
                [alert addAction:yesdelete];
                [alert addAction:nocancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
        [self.GCBalanceLabel setText:cardbalance];
    } else {
        [self.GCCodeLabel setText:@"No Gift Card Selected"];
        [self.GCBalanceLabel setText:@""];
    }
}

- (void)deleteGiftCard {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GiftCards"];
    self.giftcards = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [context deleteObject:self.giftcard];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

void freeRawData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}

- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
    
    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    unsigned char *pixels = (*resultCode).data;
    int width = (*resultCode).width;
    int len = width * width;
    
    if (imageWidth < width)
        imageWidth = width;
    
    // Set bit-fiddling variables
    int bytesPerPixel = 4;
    int bitsPerPixel = 8 * bytesPerPixel;
    int bytesPerLine = bytesPerPixel * imageWidth;
    int rawDataSize = bytesPerLine * imageWidth;
    
    int pixelPerDot = imageWidth / width;
    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
    
    // Allocate raw image buffer
    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
    memset(rawData, 0xFF, rawDataSize);
    
    // Fill raw image buffer with image data from QR code matrix
    int i;
    for (i = 0; i < len; i++) {
        char intensity = (pixels[i] & 1) ? 0 : 0xFF;
        
        int y = i / width;
        int x = i - (y * width);
        
        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
        int startY = pixelPerDot * y + offset;
        int endX = startX + pixelPerDot * bytesPerPixel;
        int endY = startY + pixelPerDot;
        
        int my;
        for (my = startY; my < endY; my++) {
            int mx;
            for (mx = startX; mx < endX; mx += bytesPerPixel) {
                rawData[bytesPerLine * my + mx    ] = intensity;    //red
                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    QRcode_free(resultCode);
    
    return quickResponseImage;
}

@end
