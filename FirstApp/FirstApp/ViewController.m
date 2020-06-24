//
//  ViewController.m
//  FirstApp
//
//  Created by Admin on 23.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

#import "ViewController.h"
#import "MyConstants.h"

@interface ViewController ()

@property (assign, nonatomic) BOOL imageMotion;
@property (assign, nonatomic) double imageSpeed;
@property (assign, nonatomic) NSTimer *timer;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIButton *button;

- (IBAction)viewButtonPress:(id)sender;
- (void)dealloc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageMotion = NO;
    
    [self.label setHidden:YES];
    [self.button setTitle:BUTTON_TXT_OFF forState:UIControlStateNormal];
}

- (void)viewImageMotion {
    CGPoint center = CGPointMake(self.view.frame.size.width / 2,
                                 self.view.frame.size.height / 2);
    
    CGFloat angle = (self.imageSpeed + DEGREE) * PI / DEGREE_180;
    if (DEGREE_360 < angle)
        angle = DEGREE_360;
    
    CGFloat new_x = center.x + cos(angle) * (self.imageView.center.x - center.x) -
                    sin(angle) * (self.imageView.center.y - center.y);
    CGFloat new_y = center.y + sin(angle) * (self.imageView.center.x - center.x) +
                    cos(angle) * (self.imageView.center.y - center.y);
    
    self.imageView.center = CGPointMake(new_x, new_y);
}

- (void)viewTimerStart {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL
                  target:self
                  selector:@selector(viewImageMotion)
                  userInfo:nil
                  repeats:YES];
}

- (void)viewTimerStop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)viewButtonPress:(id)sender {
    if ([self.textField hasText]) {
        self.imageMotion = !self.imageMotion;
        self.imageSpeed = [self.textField.text doubleValue];
        
        NSString *buttonText = self.imageMotion ? BUTTON_TXT_ON : BUTTON_TXT_OFF;
        [self.button setTitle:buttonText forState:UIControlStateNormal];
        
        if (self.imageMotion)
            [self viewTimerStart];
        else
            [self viewTimerStop];
    }
    else {
        self.label.text = LABEL_WARN_TXT;
        [self.label setHidden:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:LABEL_WARN_TIME];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.label setHidden:YES];
            });
        });
    }
}

- (void)dealloc {
    [self viewTimerStop];
    
    [self.imageView release];
    [self.textField release];
    [self.label release];
    [self.button release];
    
    [super dealloc];
}

@end
