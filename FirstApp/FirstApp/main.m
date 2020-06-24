//
//  main.m
//  FirstApp
//
//  Created by Admin on 23.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    Class appDelegate = [[AppDelegate class] autorelease];
    NSString *appDelegateClassName = NSStringFromClass(appDelegate);

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
