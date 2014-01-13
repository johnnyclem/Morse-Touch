//
//  MTTorchController.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTTorchController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+MorseCode.h"

@interface MTTorchController ()

@property (nonatomic, strong) NSOperationQueue *morseCodeQueue;
@property NSInteger unitDuration;

@end

@implementation MTTorchController

+ (MTTorchController *)sharedTorch
{
    static dispatch_once_t pred;
    static MTTorchController *singleton = nil;
    
    dispatch_once(&pred, ^{
        singleton = [[MTTorchController alloc] init];
        singleton.morseCodeQueue = [NSOperationQueue new];
        [singleton.morseCodeQueue setMaxConcurrentOperationCount:1];
        singleton.unitDuration = 100000;
    });
    return singleton;
}

- (void)sendMorseArrayToTorch:(NSArray *)morseArray
{
    MTTorchController __weak *weakSelf = self;
    
    // Loop through the codes in the message
    for (NSString *code in morseArray) {
        // Loop through the dis and dahs for each code
        for (int i=0; i < code.length; i++) {
            // get the current symbol within this code
            NSString *currentSymbol = [code substringWithRange:NSMakeRange(i, 1)];
            NSLog(@"Sending %@ to torch", currentSymbol);
            // wrap the torch comman in a block for the single-lane morse code queue
            [_morseCodeQueue addOperationWithBlock:^{
                if ([currentSymbol isEqualToString:@"."]) {
                    // send a short (one-unit) flash for a 'dit'
                    [weakSelf shortFlash];
                } else if ([currentSymbol isEqualToString:@"-"]) {
                    // send a long (two-units) flash for a 'dot'
                    [weakSelf longFlash];
                } else {
                    // send a medium gap (five-units) pause for the end of a word ' '
                    [weakSelf pauseBetweenWords];
                }
                
                if (i == code.length - 1)
                {
                    [self.delegate performSelector:@selector(displayNextLetter)];
                }
            }];
        }
    }
    
}

- (void)shortFlash
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [self turnOnFlash:device];
        usleep(self.unitDuration);
        [self turnOffFlash:device];
        usleep(self.unitDuration);
        [self pauseBetweenLetters];
    }
}

- (void)longFlash
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [self turnOnFlash:device];
        usleep(3 * self.unitDuration);
        [self turnOffFlash:device];
        [self pauseBetweenLetters];
        [self pauseBetweenLetters];
    }
}

- (void)pauseBetweenWords
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        usleep(5 * self.unitDuration);
        [device unlockForConfiguration];
    }
}

- (void)pauseBetweenLetters
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        usleep(self.unitDuration);
        [device unlockForConfiguration];
    }
}

- (void)turnOnFlash:(AVCaptureDevice *)device
{
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device setFlashMode:AVCaptureFlashModeOn];
    [device unlockForConfiguration];
}

- (void)turnOffFlash:(AVCaptureDevice *)device
{
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOff];
    [device setFlashMode:AVCaptureFlashModeOff];
    [device unlockForConfiguration];
}

@end
