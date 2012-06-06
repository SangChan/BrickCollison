//
//  AppDelegate.h
//  BrickCollision
//
//  Created by SangChan Lee on 12. 6. 6..
//  Copyright gyaleon@paran.com 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
