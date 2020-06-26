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

@property (retain, nonatomic) NSMutableArray *images;
@property (retain, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger imageTag;
@property (assign, nonatomic) double imageSize;

@property (assign, nonatomic) BOOL motion;
@property (assign, nonatomic) double motionRadius;
@property (assign, nonatomic) double motionStep;

// I have a question!
//@property (assign, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimer *timer;
@property (assign, nonatomic) double timerInterval;

@property (assign, nonatomic) double speed;
@property (assign, nonatomic) int count;

@property (retain, nonatomic) IBOutlet UITextField *countTextField;
@property (retain, nonatomic) IBOutlet UITextField *speedTextField;
@property (retain, nonatomic) IBOutlet UIButton *button;

+ (double)radToDeg:(double)rad;

- (void)loadView;
- (void)viewDidLoad;

- (void)viewInformationAlert:(NSString *)msg;

- (void)viewImagesMotion;

- (void)viewTimerStart;
- (void)viewTimerStop;

- (void)viewSubviewsCreate;
- (void)viewSubviewsClear;

- (IBAction)viewButtonPress:(id)sender;

- (void)dealloc;

@end

@implementation ViewController

+ (double)radToDeg:(double)rad {
    return rad * M_PI / 180;
}

- (void)loadView {
    [super loadView];
    
    self.images = [[NSMutableArray alloc] init];
    self.image = [UIImage systemImageNamed:@"circle"];
    
    self.imageTag = IMAGE_TAG;
    self.imageSize = IMAGE_SIZE;
    
    self.motion = NO;
    self.motionRadius = MOTION_RADIUS;
    self.motionStep = MOTION_STEP;
    
    self.timerInterval = TIMER_INTERVAL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button setTitle:BUTTON_TXT_OFF forState:UIControlStateNormal];
}

- (void)viewInformationAlert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Warning"
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *_Nonnull action){}];
    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)viewImagesMotion {
    CGPoint center = CGPointMake(self.view.frame.size.width / 2,
                                 self.view.frame.size.height / 2);
    
    CGFloat angle = [ViewController radToDeg:self.speed + self.motionStep];

    for (UIImageView *image in self.images) {
        CGFloat newX = center.x + cos(angle) * (image.center.x - center.x) -
                        sin(angle) * (image.center.y - center.y);
        CGFloat newY = center.y + sin(angle) * (image.center.x - center.x) +
                        cos(angle) * (image.center.y - center.y);
        
        image.center = CGPointMake(newX, newY);
    }
}

- (void)viewTimerStart {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                  target:self
                  selector:@selector(viewImagesMotion)
                  userInfo:nil
                  repeats:YES];
}

- (void)viewTimerStop {
    if (self.timer) {
        [self.timer invalidate];
        //[self.timer release];
        self.timer = nil;
    }
}

- (void)viewSubviewsCreate {
    // Center of image motion area, based on image size
    CGPoint center = CGPointMake((self.view.frame.size.width - self.imageSize) / 2,
                                 (self.view.frame.size.height - self.imageSize) / 2);
    
    for (int i = 0; i != self.count; ++i) {
        // Image position on the border of circle
        double angle = [ViewController radToDeg:90 + 360 / self.count * i];
        
        double x = center.x + self.motionRadius * cos(angle);
        double y = center.y + self.motionRadius * sin(angle);
        
        UIImageView *newView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, self.imageSize, self.imageSize)];
        
        newView.image = self.image;
        newView.tag = self.imageTag;
        
        // Add image to the images array and subviews
        [self.images addObject:newView];
        [self.view addSubview:newView];
        
        [newView autorelease];
    }
    
    // Redraw the view
    [self.view setNeedsDisplay];
}

- (void)viewSubviewsClear {
    for (UIView *subview in self.view.subviews)
        if (subview.tag == self.imageTag)
            [subview removeFromSuperview];
}

- (IBAction)viewButtonPress:(id)sender {
    if (self.motion == NO && [self.countTextField hasText] && [self.speedTextField hasText] || self.motion) {
        NSString *buttonText = self.motion ? BUTTON_TXT_OFF : BUTTON_TXT_ON;
        [self.button setTitle:buttonText forState:UIControlStateNormal];
        
        if (self.motion == NO) {
            self.count = [self.countTextField.text intValue];
            self.speed = [self.speedTextField.text doubleValue];
            
            [self viewSubviewsClear];
            [self viewSubviewsCreate];
            
            [self viewTimerStart];
        }
        else
            [self viewTimerStop];
        
        self.motion = !self.motion;
    }
    else
        if ([self.countTextField hasText] == NO)
            [self viewInformationAlert:@"Enter the images count!"];
        else
            if ([self.speedTextField hasText] == NO)
                [self viewInformationAlert:@"Enter the movement speed!"];
}

- (void)dealloc {
    [self viewTimerStop];
    
    [self.images release];
    [self.image release];
    
    [self.speedTextField release];
    [self.countTextField release];
    [self.button release];
    
    [super dealloc];
}

@end
