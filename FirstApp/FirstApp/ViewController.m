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

@property (assign, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger imageTag;
@property (assign, nonatomic) CGFloat imageSize;

@property (assign, nonatomic) BOOL motion;
@property (assign, nonatomic) CGFloat motionRadius;
@property (assign, nonatomic) CGFloat motionStep;

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat timerInterval;

@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) CGFloat speed;

@property (retain, nonatomic) IBOutlet UITextField *countTextField;
@property (retain, nonatomic) IBOutlet UITextField *speedTextField;
@property (retain, nonatomic) IBOutlet UIButton *button;

+ (CGFloat)radianToDegree:(CGFloat)radian;

- (void)loadView;
- (void)viewDidLoad;

- (void)showAlertMessage:(NSString *)message;

- (void)moveImages;

- (void)startTimer;
- (void)stopTimer;

- (void)createSubviews;
- (void)destroySubviews;

- (IBAction)didPressButton:(id)sender;

- (void)dealloc;

@end

@implementation ViewController

+ (CGFloat)radianToDegree:(CGFloat)radian {
    return radian * M_PI / 180;
}

- (void)loadView {
    [super loadView];
    
    self.images = [[NSMutableArray alloc] init];
    [self.images release];
    self.image = [UIImage systemImageNamed:@"circle"];
    
    self.imageTag = ImageTag;
    self.imageSize = ImageSize;
    
    self.motion = NO;
    self.motionRadius = MotionRadius;
    self.motionStep = MotionStep;
    
    self.timerInterval = TimerInterval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.button setTitle:ButtonTextOff forState:UIControlStateNormal];
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Warning"
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *_Nonnull action) {}];
    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)moveImages {
    CGRect frame = self.view.frame;
    CGPoint center = CGPointMake(CGRectGetWidth(frame) / 2,
                                 CGRectGetHeight(frame) / 2);
    
    CGFloat angle = [ViewController radianToDegree:self.speed + self.motionStep];

    for (UIImageView *image in self.images) {
        CGFloat newX = center.x + cos(angle) * (image.center.x - center.x) -
                       sin(angle) * (image.center.y - center.y);
        CGFloat newY = center.y + sin(angle) * (image.center.x - center.x) +
                       cos(angle) * (image.center.y - center.y);
        
        image.center = CGPointMake(newX, newY);
    }
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                  target:self
                  selector:@selector(moveImages)
                  userInfo:nil
                  repeats:YES];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)createSubviews {
    // Center of image motion area, based on image size
    CGRect frame = self.view.frame;
    CGPoint center = CGPointMake((CGRectGetWidth(frame) - self.imageSize) / 2,
                                 (CGRectGetHeight(frame) - self.imageSize) / 2);
    
    for (NSUInteger i = 0; i != self.count; ++i) {
        // Image position on the border of circle
        CGFloat angle = [ViewController radianToDegree:90 + 360 / self.count * i];
        
        CGFloat x = center.x + self.motionRadius * cos(angle);
        CGFloat y = center.y + self.motionRadius * sin(angle);
        
        UIImageView *newView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, self.imageSize, self.imageSize)];
        
        newView.image = self.image;
        newView.tag = self.imageTag;
        
        // Add image to the images array and subviews
        [self.images addObject:newView];
        [self.view addSubview:newView];
        
        [newView release];
    }
}

- (void)destroySubviews {
    [self.images removeAllObjects];
    
    for (UIView *subview in self.view.subviews) {
        if (subview.tag == self.imageTag) {
            [subview removeFromSuperview];
        }
    }
}

- (IBAction)didPressButton:(id)sender {
    if (!self.motion && [self.countTextField hasText] && [self.speedTextField hasText] || self.motion) {
        NSString *buttonText = self.motion ? ButtonTextOff : ButtonTextOn;
        [self.button setTitle:buttonText forState:UIControlStateNormal];
        
        if (!self.motion) {
            self.count = [self.countTextField.text intValue];
            self.speed = [self.speedTextField.text doubleValue];
            
            [self destroySubviews];
            [self createSubviews];
            
            [self startTimer];
        }
        else {
            [self stopTimer];
        }
        
        self.motion = !self.motion;
    }
    else {
        if (![self.countTextField hasText]) {
            [self showAlertMessage:@"Enter the images count!"];
        }
        else {
            if (![self.speedTextField hasText]) {
                [self showAlertMessage:@"Enter the movement speed!"];
            }
        }
    }
}

- (void)dealloc {
    [self stopTimer];
    [self destroySubviews];
    
    [self.images release];
    [self.image release];
    
    [self.speedTextField release];
    [self.countTextField release];
    
    [super dealloc];
}

@end
