//
//  ILTextMateLionizer.m
//  Lionize
//
//  Created by ∞ on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILTextMateLionSupport.h"

@protocol TMPlugInController <NSObject>
- (float)version;
@end


@interface ILTextMateLionSupport ()
- (void) makeWindowsFullScreen;
- (BOOL) isWindowADocumentOrProjectWindow:(NSWindow*) w;
@end

@implementation ILTextMateLionSupport

- (id)initWithPlugInController:(id <TMPlugInController>)aController;
{
    self = [super init];
    if (self) {
        documentControllerClass = NSClassFromString(@"OakDocumentController");
        projectControllerClass = NSClassFromString(@"OakProjectController");
        
        [self makeWindowsFullScreen];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKeyOrMain:) name:NSWindowDidBecomeKeyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKeyOrMain:) name:NSWindowDidBecomeMainNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)makeWindowsFullScreen;
{
    for (NSWindow* w in [NSApp orderedWindows]) {
        if ([self isWindowADocumentOrProjectWindow:w])
            w.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    }
}

- (BOOL)isWindowADocumentOrProjectWindow:(NSWindow *)w;
{
    if (documentControllerClass && [w.windowController isKindOfClass:documentControllerClass])
        return YES;
    
    if (projectControllerClass && [w.windowController isKindOfClass:projectControllerClass])
        return YES;
    
    return NO;
}

- (void) windowDidBecomeKeyOrMain:(NSNotification*) n;
{
    NSWindow* w = [n object];
    if ([self isWindowADocumentOrProjectWindow:w])
        w.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
}

@end

