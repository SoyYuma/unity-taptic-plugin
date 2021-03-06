//
//  UnityTapticPlugin.m
//  unity-taptic-plugin
//
//  Created by Koki Ibukuro on 12/6/16.
//  Modified by Ale Cámara in 2019.
//
//  Licensed under MIT License.
//  See LICENSE in root directory.
//

#import "UnityTapticPlugin.h"

#pragma mark - UnityTapticPlugin

@interface UnityTapticPlugin ()
@property (nonatomic, strong) UINotificationFeedbackGenerator* notificationGenerator;
@property (nonatomic, strong) UISelectionFeedbackGenerator* selectionGenerator;
@property (nonatomic, strong) NSArray<UIImpactFeedbackGenerator*>* impactGenerators;
@end

@implementation UnityTapticPlugin

static UnityTapticPlugin * _shared;

+ (UnityTapticPlugin*) shared
{
    @synchronized(self)
    {
        if(_shared == nil)
        {
            _shared = [[self alloc] init];
        }
    }
    return _shared;
}

- (id) init
{
    if (self = [super init])
    {
        self.notificationGenerator = [UINotificationFeedbackGenerator new];
        self.selectionGenerator = [UISelectionFeedbackGenerator new];
        self.impactGenerators = @[
             [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight],
             [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium],
             [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy],
        ];
    }
    return self;
}

- (void) dealloc
{
    self.notificationGenerator = NULL;
    self.selectionGenerator = NULL;
    self.impactGenerators = NULL;
}

- (void) prepareNotification
{
    [self.notificationGenerator prepare];
}

- (void) triggerNotification:(UINotificationFeedbackType)type
{
    [self.notificationGenerator notificationOccurred:type];
}

- (void) prepareSelection
{
    [self.selectionGenerator prepare];
}

- (void) triggerSelection
{
    [self.selectionGenerator selectionChanged];
}

- (void) prepareImpact:(UIImpactFeedbackStyle)style
{
    [self.impactGenerators[(int) style] prepare];
}

- (void) triggerImpact:(UIImpactFeedbackStyle)style
{
    [self.impactGenerators[(int) style] impactOccurred];
}

+ (BOOL) isSupported
{
    // http://stackoverflow.com/questions/39564510/check-if-device-supports-uifeedbackgenerator-in-ios-10
    
    // Private API
    // NSNumber* support = [[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"];
    // return support.intValue == 2;

    if ([UINotificationFeedbackGenerator class]) {
        return YES;
    }
    return NO;
    
}

@end

#pragma mark - Unity Bridge

extern "C"
{
    void _unityTapticPrepareNotification()
    {
        [[UnityTapticPlugin shared] prepareNotification];
    }

    void _unityTapticTriggerNotification(int type)
    {
        [[UnityTapticPlugin shared] triggerNotification:(UINotificationFeedbackType) type];
    }
    
    void _unityTapticPrepareSelection()
    {
        [[UnityTapticPlugin shared] prepareSelection];
    }

    void _unityTapticTriggerSelection()
    {
        [[UnityTapticPlugin shared] triggerSelection];
    }

    void _unityTapticPrepareImpact(int style)
    {
        [[UnityTapticPlugin shared] prepareImpact:(UIImpactFeedbackStyle) style];
    }
    
    void _unityTapticTriggerImpact(int style)
    {
        [[UnityTapticPlugin shared] triggerImpact:(UIImpactFeedbackStyle) style];
    }
    
    bool _unityTapticIsSupported()
    {
        return [UnityTapticPlugin isSupported];
    }
}
