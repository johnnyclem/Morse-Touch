//
//  MTViewController.m
//  Morse Torch
//
//  Created by John Clem on 1/8/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTViewController.h"
#import "NSString+MorseCode.h"

@interface MTViewController ()

- (IBAction)sendMorseCodeMessage:(id)sender;

@property (nonatomic, weak) IBOutlet UITextField *messageField;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property NSInteger tempNumber;


@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageField.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMorseCodeMessage:(id)sender
{
    [self.messageField resignFirstResponder];
    NSString *messageString = _messageField.text;
    
    self.tempNumber = 0;
    NSLog(@"Converting Message To Morse Array: %@", messageString);
    NSArray *morseArray = [NSString morseArrayFromString:messageString];
    [self sendMessageToTorch:morseArray];
    
    NSString *tempString =  [self.messageField.text substringWithRange:NSMakeRange(self.tempNumber, 1)];
    [self.textLabel performSelectorOnMainThread:@selector(setText:) withObject:tempString waitUntilDone:NO];
}

- (void)sendMessageToTorch:(NSArray *)messageArray
{
    NSLog(@"Sending Morse Array To Torch: %@", messageArray);
    MTTorchController *torch = [MTTorchController sharedTorch];
    torch.delegate = self;
    [torch sendMorseArrayToTorch:messageArray];
}

-(void)displayNextLetter
{
    self.tempNumber++;
    if (self.tempNumber < self.messageField.text.length)
    {
        NSString *tempString =  [self.messageField.text substringWithRange:NSMakeRange(self.tempNumber, 1)];
        [self.textLabel performSelectorOnMainThread:@selector(setText:) withObject:tempString waitUntilDone:NO];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
@end
