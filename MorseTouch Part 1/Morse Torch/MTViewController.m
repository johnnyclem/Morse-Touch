//
//  MTViewController.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTViewController.h"
#import "NSString+MorseCode.h"
#import "MTTorchController.h"

@interface MTViewController ()

- (IBAction)sendMorseCodeMessage:(id)sender;

@property (nonatomic, weak) IBOutlet UITextField *messageField;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMorseCodeMessage:(id)sender
{
    NSString *messageString = _messageField.text;
    NSLog(@"Converting Message To Morse Array: %@", messageString);
    NSArray *morseArray = [NSString morseArrayFromString:messageString];
    [self sendMessageToTorch:morseArray];
}

- (void)sendMessageToTorch:(NSArray *)messageArray
{
    NSLog(@"Sending Morse Array To Torch: %@", messageArray);
    [[MTTorchController sharedTorch] sendMorseArrayToTorch:messageArray];
}

@end
