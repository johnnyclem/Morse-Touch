//
//  MTReceiveViewController.m
//  Morse Torch
//
//  Created by John Clem on 1/14/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTReceiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface MTReceiveViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    NSInteger brightFrames;
}
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic) AVCaptureSession *session;

- (IBAction)startReceiving:(id)sender;

@end

@implementation MTReceiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    brightFrames = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVFoundation

- (IBAction)startReceiving:(id)sender
{
    [self setupCamera];
}

- (void)setupCamera
{
	// Create a AVCaptureInput with the camera device
	NSError *error=nil;
    
    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
	
    if (error) {
        
		NSLog(@"Error to create camera capture:%@",error);
        
	} else {

        // Set the output
        AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        // create a queue to run the capture on
        dispatch_queue_t captureQueue=dispatch_queue_create("captureQueue", NULL);
        
        // setup our delegate
        [videoOutput setSampleBufferDelegate:self queue:captureQueue];
        
        // configure the pixel format
        videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
        
        // discard dropped frames, we won't need them
//        videoOutput.alwaysDiscardsLateVideoFrames = YES;
        
        // alloc/init the session
        _session = [[AVCaptureSession alloc] init];
        
        // and the size of the frames we want
        [_session setSessionPreset:AVCaptureSessionPresetLow];
        
        // Add the input and output
        [_session addInput:cameraInput];
        [_session addOutput:videoOutput];
        
        [camera lockForConfiguration:&error];
        [camera setExposureMode:AVCaptureExposureModeLocked];
        [camera unlockForConfiguration];
        
        [self configureCameraForHighestFrameRate:camera];
        
        // Start the session
        [_session startRunning];

    }
	
}

- (void)configureCameraForHighestFrameRate:(AVCaptureDevice *)device
{
    AVCaptureDeviceFormat *bestFormat = nil;
    AVFrameRateRange *bestFrameRateRange = nil;
    for ( AVCaptureDeviceFormat *format in [device formats] ) {
        for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
            if ( range.maxFrameRate > bestFrameRateRange.maxFrameRate ) {
                bestFormat = format;
                bestFrameRateRange = range;
            }
        }
    }
    if ( bestFormat ) {
        if ( [device lockForConfiguration:NULL] == YES ) {
            device.activeFormat = bestFormat;
            device.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
            device.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
            [device unlockForConfiguration];
        }
    }
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSDictionary* dict = (__bridge NSDictionary *)(CMGetAttachment(sampleBuffer, kCGImagePropertyExifDictionary, NULL));
    
    if ([dict[@"BrightnessValue"] floatValue] > 1.5) {
        brightFrames = brightFrames + 1;
    } else {
        [self logSymbol];
    }
    

}

- (void)logSymbol
{
    if (brightFrames > 10) {
        NSLog(@"-");
    } else if (brightFrames > 5) {
        NSLog(@".");
    }
    brightFrames = 0;
}

@end
