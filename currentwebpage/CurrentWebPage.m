//
//  CurrentWebPage.m
//  currentwebpage


#import "CurrentWebPage.h"

#define kSafariAppName @"Safari"
#define kChromeAppName @"Google Chrome"

#define kSafariShortName @"safari"
#define kChromeShortName @"chrome"


// Safari か Chrome を探す
// prefer に @"safari" か @"chrome" を渡すとそっちだけを探す。自動判別なら nil を渡す
// return @"safari" or @"chrome" or nil
NSString* CurrentWebPageCurrentBrowser(NSString* prefer)
{
    NSString* result=nil;
    CFArrayRef list =CGWindowListCopyWindowInfo( kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    int i;
    CFIndex cnt=CFArrayGetCount(list);
    
    for (i=0; i < cnt; i++) {
        CFDictionaryRef w = CFArrayGetValueAtIndex(list, i);
        CFStringRef ownerName=CFDictionaryGetValue(w, kCGWindowOwnerName);

        if ([kSafariAppName isEqualToString:(__bridge NSString *)(ownerName)]) {
            if([prefer length]==0 || [prefer isEqualToString:kSafariShortName]){
                result=kSafariShortName;
                break;
            }
        }else if ([kChromeAppName isEqualToString:(__bridge NSString *)(ownerName)]) {
            if([prefer length]==0 || [prefer isEqualToString:kChromeShortName]){
                result=kChromeShortName;
                break;
            }
        }
    }
    CFRelease(list);
    return result;
}



// Safari で表示しているURLとタイトルを取ってくる
// Safari が起動しているかは事前にチェックしておくこと
NSDictionary* CurrentWebPageSafariInfoInternal()
{
    NSAppleScript *scpt=[[NSAppleScript alloc]initWithSource:@"tell application \"Safari\"\nreturn {URL of document 1, name of document 1}\nend tell"];
    
    NSAppleEventDescriptor *scptResult=[scpt executeAndReturnError:nil];
    if ([scptResult numberOfItems]!=2) {
#if !__has_feature(objc_arc)
        [scpt release];
#endif
        return nil;
    }
    
    NSString* url=[[scptResult descriptorAtIndex:1]stringValue];
    if (!url) {
        url=@"";
    }
    NSString* title=[[scptResult descriptorAtIndex:2]stringValue];
    if (!title) {
        title=@"";
    }

#if !__has_feature(objc_arc)
    [scpt release];
#endif
    
    NSDictionary* result=[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", title, @"title", nil];
    return result;
}

// Chrome で表示しているURLとタイトルを取ってくる
// Chrome が起動しているかは事前にチェックしておくこと
NSDictionary* CurrentWebPageChromeInfoInternal()
{
    NSAppleScript *scpt=[[NSAppleScript alloc]initWithSource:@"tell application \"Google Chrome\"\nset t to tab (active tab index of window 1) of window 1\nreturn {URL of t, title of t}\nend tell"];
    NSAppleEventDescriptor *scptResult=[scpt executeAndReturnError:nil];
    
    if ([scptResult numberOfItems]!=2) {
#if !__has_feature(objc_arc)
        [scpt release];
#endif
        return nil;
    }
    
    NSString* url=[[scptResult descriptorAtIndex:1]stringValue];
    if (!url) {
        url=@"";
    }
    NSString* title=[[scptResult descriptorAtIndex:2]stringValue];
    if (!title) {
        title=@"";
    }

#if !__has_feature(objc_arc)
    [scpt release];
#endif
    
    NSDictionary* result=[NSDictionary dictionaryWithObjectsAndKeys:url, @"url", title, @"title", nil];
    return result;
}

// Safari で表示しているURLとタイトルを取ってくる
NSDictionary* CurrentWebPageSafariInfo()
{
    NSString* currentBrowser=CurrentWebPageCurrentBrowser(kSafariShortName);
    if (currentBrowser) {
        return CurrentWebPageSafariInfoInternal();
    }
    return nil;
}

// Chrome で表示しているURLとタイトルを取ってくる
NSDictionary* CurrentWebPageChromeInfo()
{
    NSString* currentBrowser=CurrentWebPageCurrentBrowser(kChromeShortName);
    if (currentBrowser) {
        return CurrentWebPageChromeInfoInternal();
    }
    return nil;
}

// Safari か Chrome で表示しているURLとタイトルを取ってくる
// prefer に @"safari" か @"chrome" を渡すとそっちだけを探す。自動判別なら nil を渡す
NSDictionary* CurrentWebPageCurrentInfo(NSString* prefer)
{
    if ([prefer isEqualToString:kSafariShortName]) {
        return CurrentWebPageSafariInfo();
    }else if ([prefer isEqualToString:kChromeShortName]){
        return CurrentWebPageChromeInfo();
    }else{
        NSString* currentBrowser=CurrentWebPageCurrentBrowser(nil);
        
        if ([currentBrowser isEqualToString:kSafariShortName]) {
            return CurrentWebPageSafariInfoInternal();
        }else if ([currentBrowser isEqualToString:kChromeShortName]) {
            return CurrentWebPageChromeInfoInternal();
        }
    }
    
    return nil;
}

