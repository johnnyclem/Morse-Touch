//
//  MTTorchController.h
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTorchController : NSObject

+ (MTTorchController *)sharedTorch;
- (void)sendMorseArrayToTorch:(NSArray *)morseArray;

@end
