//
//  MTReceiveViewController.m
//  Morse Torch
//
//  Created by John Clem on 1/14/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "MTReceiveViewController.h"

@interface MTReceiveViewController ()
{
    NSInteger onCount;
    NSInteger offCount;
}

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UISlider *brightnessSlider;

- (IBAction)startReceiving:(id)sender;

@end

@implementation MTReceiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventDetected:) name:@"onMagicEventDetected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOnMagicEventNotDetected:) name:@"onMagicEventNotDetected" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_brightnessSlider setEnabled:NO];
    
    onCount = 0;
    offCount = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)startReceiving:(id)sender
{
    [self setupCamera];
}

- (IBAction)updateBrightnessThreshold:(UISlider *)slider
{
    [_magicEvents updateBrightnessThreshold:slider.value];
}

- (void)setupCamera
{
    _magicEvents  = [[CFMagicEvents alloc] init];
    if ([_magicEvents startCapture]) {
        [_brightnessSlider setEnabled:YES];
        [_brightnessSlider setValue:_magicEvents.brightnessThreshold animated:YES];
    }
}

#pragma mark - MagicEvents

- (void)receiveOnMagicEventDetected:(NSNotification *)note
{
    offCount = 0;
    onCount ++;
}

- (void)receiveOnMagicEventNotDetected:(NSNotification *)note
{
    if (onCount >= 2) {
        NSLog(@"-");
    } else if (onCount > 0) {
        NSLog(@".");
    }
    
    onCount = 0;
    offCount ++;
}

@end
