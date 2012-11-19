//
//  main.m
//  currentwebpage


#import <Foundation/Foundation.h>
#import "CurrentWebPage.h"
#include <libgen.h>

void printHelp(const char * name)
{
    fprintf(stdout, "take URL and title from current web browser (Safari and Chrome)\n\n");
    fprintf(stdout, "usage: %s [-hutsc]\n", basename((char *)name));
    fprintf(stdout, "  -h: show this help\n");
    fprintf(stdout, "  -u: URL only\n");
    fprintf(stdout, "  -t: title only \n");
    fprintf(stdout, "  -s: Safari only\n");
    fprintf(stdout, "  -c: Chrome only\n");
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        BOOL showHelp=NO;
        BOOL urlOnly=NO;
        BOOL titleOnly=NO;
        NSString* preferBrowser=nil;
        int i;
        NSString* options=@"";
        
        //プログラム名でオプションを設定
        NSString* programName=[NSString stringWithFormat:@"%s", basename((char*)argv[0])];
        if ([programName rangeOfString:@"Safari"].length) {
            preferBrowser=@"safari";
        }else if ([programName rangeOfString:@"Chrome"].length) {
            preferBrowser=@"chrome";
        }
        if ([programName rangeOfString:@"URL"].length) {
            urlOnly=YES;
        }else if ([programName rangeOfString:@"Title"].length) {
            titleOnly=YES;
        }
        
        //引数でオプションを設定
        for (i=1; i<argc; i++) {
            const char * op=argv[i];
            options=[NSString stringWithFormat:@"%@%s", options, op];
        }
        options=[options lowercaseString];
        
        if ([options rangeOfString:@"h"].length) {
            showHelp=YES;
        }
        if ([options rangeOfString:@"u"].length) {
            urlOnly=YES;
        }
        if ([options rangeOfString:@"t"].length) {
            titleOnly=YES;
        }
        if ([options rangeOfString:@"s"].length) {
            preferBrowser=@"safari";
        }else if ([options rangeOfString:@"c"].length) {
            preferBrowser=@"chrome";
        }
        
        if (urlOnly && titleOnly) {
            urlOnly=NO;
            titleOnly=NO;
        }
        
        //実行
        if (showHelp) {
            printHelp(argv[0]);
            return 0;
        }
        NSDictionary* result=CurrentWebPageCurrentInfo(preferBrowser);
        
        if (!titleOnly) {
            NSString* outString=result[@"url"];
            if(outString)fprintf(stdout, "%s\n", [outString UTF8String]);

        }
        if (!urlOnly) {
            NSString* outString=result[@"title"];
            if(outString)fprintf(stdout, "%s\n", [outString UTF8String]);
        }
    }
    return 0;
}

