//
//  NSString+MorseCode.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "NSString+MorseCode.h"

@implementation NSString (MorseCode)

+ (NSString *)stringFromMorseCodeArray:(NSArray *)morseArray
{
    NSMutableString *morseString = [NSMutableString new];
    for (NSString *code in morseArray) {
        NSAssert([[[NSString morseCodeDictionary] allKeysForObject:code] count], @"Code not found, did you make a typo?");
        NSString *character = [[[NSString morseCodeDictionary] allKeysForObject:code] objectAtIndex:0];
        [morseString appendString:character];
    }

    return morseString;
}

+ (NSArray *)morseArrayFromString:(NSString *)morseString
{
    NSMutableArray *morseArray = [NSMutableArray new];
    
    for(int i =0; i < morseString.length; i++) {
        char character = [morseString characterAtIndex:i];
        NSString *morseString = [NSString morseCodeForCharacter:character];
        [morseArray addObject:morseString];
    }
    
    return morseArray;
}

+ (NSString *)morseCodeForCharacter:(char)character
{
    NSString *keyString = [[NSString stringWithFormat:@"%c", character] uppercaseString];
    NSString *codeString = [[NSString morseCodeDictionary] objectForKey:keyString];
    NSLog(@"Converting %@ to %@", keyString, codeString);
    
    return codeString;
}

+ (NSString *)characterForMorseCode:(NSString *)code
{
    NSAssert(code.length > 0 && code.length <= 4, @"Length of code must be between 1-4 characters");
    NSAssert([[[NSString morseCodeDictionary] allKeysForObject:code] count], @"Code not found, did you make a typo?");
    
    return [[[NSString morseCodeDictionary] allKeysForObject:code] objectAtIndex:0];
}

+ (NSDictionary *)morseCodeDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @".-", @"A",
            @"-...", @"B",
            @"-.-.", @"C",
            @"-..", @"D",
            @".", @"E",
            @"..-.", @"F",
            @"--.", @"G",
            @"....", @"H",
            @"..", @"I",
            @".---", @"J",
            @"-.-", @"K",
            @".-..", @"L",
            @"--", @"M",
            @"-.", @"N",
            @"---", @"O",
            @".--.", @"P",
            @"--.-", @"Q",
            @".-.", @"R",
            @"...", @"S",
            @"-", @"T",
            @"..-", @"U",
            @"...-", @"V",
            @".--", @"W",
            @"-..-", @"X",
            @"-.--", @"Y",
            @"--..", @"Z",
            @" ", @" ",
            @"STOP", @".",
            nil];
}

@end
