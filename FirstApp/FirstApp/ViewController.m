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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgMotion = NO;
    
    [_label setHidden:YES];
    [_button setTitle:BUTTON_TXT_OFF forState:UIControlStateNormal];
}

- (void)viewImageMotion {
    CGPoint center = CGPointMake(self.view.frame.size.width / 2,
                                 self.view.frame.size.height / 2);
    
    CGFloat angle = DEGREE * PI / 180;
    
    CGFloat new_x = center.x + cos(angle) * (_imageView.center.x - center.x) -
                    sin(angle) * (_imageView.center.y - center.y);
    CGFloat new_y = center.y + sin(angle) * (_imageView.center.x - center.x) +
                    cos(angle) * (_imageView.center.y - center.y);
    
    _imageView.center = CGPointMake(new_x, new_y);
}

- (IBAction)viewButtonPress:(id)sender {
    if ([_textField hasText]) {
        double speed = [_textField.text doubleValue];
        
        imgMotion = !imgMotion;
        NSString* buttonText = imgMotion ? BUTTON_TXT_ON : BUTTON_TXT_OFF;
        
        [_button setTitle:buttonText forState:UIControlStateNormal];
        
        if (imgMotion) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                while (self->imgMotion) {
                    [NSThread sleepForTimeInterval:SPEED_MAX / speed];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewImageMotion];
                    });
                }
            });
        }
    }
    else {
        _label.text = LABEL_WARN_TXT;
        [_label setHidden:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:LABEL_WARN_TIME];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_label setHidden:YES];
            });
        });
    }
}

@end
