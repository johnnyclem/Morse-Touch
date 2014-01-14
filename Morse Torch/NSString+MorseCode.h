//
//  NSString+MorseCode.h
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

+ (NSString *)stringFromMorseCodeArray:(NSArray *)morseArray;
+ (NSArray *)morseArrayFromString:(NSString *)morseString;
+ (NSString *)morseCodeForCharacter:(char)character;
+ (NSString *)characterForMorseCode:(NSString *)code;

@end
