//
//  MTTorchController.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTTorchController.h"
#import "NSString+MorseCode.h"
#import <AVFoundation/AVFoundation.h>

@interface MTTorchController ()

@property (nonatomic, strong) NSOperationQueue *morseCodeQueue;
@property useconds_t unitDuration;

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
    // Loop through the codes in the message
    for (NSString *code in morseArray) {
        // Inform the delegate that we are sending currentSymbol
        [_morseCodeQueue addOperationWithBlock:^{
            [_delegate sendingCharacter:[NSString characterForMorseCode:code]];
        }];
        // Loop through the dis and dahs for each code
        for (int i=0; i < code.length; i++) {
            // get the current symbol within this code
            NSString *currentSymbol = [code substringWithRange:NSMakeRange(i, 1)];
            // wrap the torch comman in a block for the single-lane morse code queue
            [_morseCodeQueue addOperationWithBlock:^{
                if ([currentSymbol isEqualToString:@"."]) {
                    // send a short (one-unit) flash for a 'dit'
                    [self shortFlash];
                } else if ([currentSymbol isEqualToString:@"-"]) {
                    // send a long (two-units) flash for a 'dot'
                    [self longFlash];
                } else {
                    // send a medium gap (five-units) pause for the end of a word ' '
                    [self pauseBetweenWords];
                }                
            }];
        }
    }
    
    [_morseCodeQueue addOperationWithBlock:^{
       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           [self.delegate didSendMessage:YES];
       }];
    }];
}

- (void)cancelMessage
{
    [_morseCodeQueue setSuspended:YES];
    [_morseCodeQueue cancelAllOperations];
    [self.delegate didSendMessage:YES];
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
        usleep(self.unitDuration * 2);
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
