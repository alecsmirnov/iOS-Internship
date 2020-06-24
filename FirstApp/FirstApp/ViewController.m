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

@property (assign, nonatomic) BOOL imgMotion;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *button;

- (IBAction)viewButtonPress:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgMotion = NO;
    
    [self.label setHidden:YES];
    [self.button setTitle:BUTTON_TXT_OFF forState:UIControlStateNormal];
}

- (void)viewImageMotion {
    CGPoint center = CGPointMake(self.view.frame.size.width / 2,
                                 self.view.frame.size.height / 2);
    
    CGFloat angle = DEGREE * PI / 180;
    
    CGFloat new_x = center.x + cos(angle) * (self.imageView.center.x - center.x) -
                    sin(angle) * (self.imageView.center.y - center.y);
    CGFloat new_y = center.y + sin(angle) * (self.imageView.center.x - center.x) +
                    cos(angle) * (self.imageView.center.y - center.y);
    
    self.imageView.center = CGPointMake(new_x, new_y);
}

- (IBAction)viewButtonPress:(id)sender {
    if ([self.textField hasText]) {
        double speed = [self.textField.text doubleValue];
        
        self.imgMotion = !self.imgMotion;
        NSString *buttonText = self.imgMotion ? BUTTON_TXT_ON : BUTTON_TXT_OFF;
        
        [_button setTitle:buttonText forState:UIControlStateNormal];
        
        if (self.imgMotion) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                while (self.imgMotion) {
                    [NSThread sleepForTimeInterval:SPEED_MAX / speed];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewImageMotion];
                    });
                }
            });
        }
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

@end
