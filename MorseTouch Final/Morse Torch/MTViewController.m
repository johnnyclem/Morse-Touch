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
#import <MBProgressHUD/MBProgressHUD.h>

@interface MTViewController ()

- (IBAction)sendMorseCodeMessage:(id)sender;

@property (nonatomic, weak) IBOutlet UITextField *messageField;
@property (nonatomic, strong) MBProgressHUD *hud;

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
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:32.f];
    
    NSString *messageString = _messageField.text;
    NSLog(@"Converting Message To Morse Array: %@", messageString);
    NSArray *morseArray = [NSString morseArrayFromString:messageString];
    [self sendMessageToTorch:morseArray];
}

- (void)sendMessageToTorch:(NSArray *)messageArray
{
    NSLog(@"Sending Morse Array To Torch: %@", messageArray);
    [[MTTorchController sharedTorch] setDelegate:self];
    [[MTTorchController sharedTorch] sendMorseArrayToTorch:messageArray];
}

#pragma mark - MTTorchControllerDelegate

- (void)sendingCharacter:(NSString *)character
{
    [_hud setLabelText:character];
}

- (void)didSendMessage:(BOOL)success
{
    if (success) {
        [_hud hide:YES];
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_hud.isHidden) {
        [[MTTorchController sharedTorch] cancelMessage];
    }
}

@end
