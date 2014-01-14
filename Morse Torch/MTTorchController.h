//
//  MTTorchController.h
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTTorchControllerDelegate <NSObject>

- (void)didSendMessage:(BOOL)success;
- (void)sendingCharacter:(NSString *)character;

@end

@interface MTTorchController : NSObject

@property (unsafe_unretained) id<MTTorchControllerDelegate> delegate;

+ (MTTorchController *)sharedTorch;
- (void)sendMorseArrayToTorch:(NSArray *)morseArray;
- (void)cancelMessage;

@end
