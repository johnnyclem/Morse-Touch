//
//  MTTorchController.h
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTTorchDelegate <NSObject>

-(void)displayNextLetter;

@end

@interface MTTorchController : NSObject

+ (MTTorchController *)sharedTorch;
- (void)sendMorseArrayToTorch:(NSArray *)morseArray;

@property (assign) id <MTTorchDelegate> delegate;

@end
