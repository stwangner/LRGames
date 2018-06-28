//
//  ViewControllerAddGiftCard.m
//  LRGames
//
//  Created by Stephen Wangner on 10/2/16.
//  Copyright © 2016 Stephen Wangner. All rights reserved.
//

#import "ViewControllerAddGiftCard.h"

@interface ViewControllerAddGiftCard ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation ViewControllerAddGiftCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_savebutton setEnabled:true];
    [_gctextfield resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_scanview.layer.bounds];
    [_scanview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
            //[_bbitemStart setTitle:@"Stop"];
            //_btnStart = @"Stop";
            [_scanbutton setTitle: @"Stop Scan" forState: UIControlStateNormal];
            //[_btnStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Stop!" waitUntilDone:NO];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
        //[_bbitemStart setTitle:@"Start!"];
        [_scanbutton setTitle: @"Start Scan" forState: UIControlStateNormal];
        [_savebutton setEnabled:true];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}

- (IBAction)savebuttonpressed:(id)sender {
    NSString *newgiftcardcode;
    
    newgiftcardcode = self.gctextfield.text;
    newgiftcardcode = [newgiftcardcode uppercaseString];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    newgiftcardcode = [[newgiftcardcode componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    
    if (newgiftcardcode.length != 16) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                       message:@"Code entered was not 16 characters.  Cannot save."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSManagedObjectContext *context = [self managedObjectContext];
    
        // Create a new managed object
        NSManagedObject *newGiftCard = [NSEntityDescription insertNewObjectForEntityForName:@"GiftCards" inManagedObjectContext:context];
    
        [newGiftCard setValue:newgiftcardcode forKey:@"cardcode"];
        [newGiftCard setValue:@" " forKey:@"balance"];
    
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelbuttonpressed:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//[[[UIApplication sharedApplication] keyWindow] endEditing:YES];

-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    
    [_scanbutton setTitle: @"Start Scan" forState: UIControlStateNormal];
    [_savebutton setEnabled:true];
    _savebutton.enabled = true;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            
            NSString *xstring=[metadataObj stringValue];
            NSString *lastsixteen=[xstring substringFromIndex:xstring.length-16];
            
            [_gctextfield performSelectorOnMainThread:@selector(setText:) withObject:lastsixteen waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            [_savebutton setEnabled:true];
            
            _isReading = NO;
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
