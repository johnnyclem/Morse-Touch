//
//  MTTorchController.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTTorchController.h"

@interface MTTorchController ()

@property (nonatomic, strong) NSOperationQueue *morseCodeQueue;

@end

@implementation MTTorchController

+ (MTTorchController *)sharedTorch
{
    static dispatch_once_t pred;
    static MTTorchController *singleton = nil;
    
    dispatch_once(&pred, ^{
        singleton = [[MTTorchController alloc] init];
    });
    return singleton;
}

- (void)sendMorseArrayToTorch:(NSArray *)morseArray
{
    // Loop through the codes in the message
    for (NSString *code in morseArray) {
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
    
}

- (void)shortFlash
{
    NSLog(@".");
}

- (void)longFlash
{
    NSLog(@"-");
}

- (void)pauseBetweenWords
{
    NSLog(@" ");
}

@end
