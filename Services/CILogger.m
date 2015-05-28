//
//  CILogger.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/27/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import "CILogger.h"
#import "NSDate+Concrete.h"
#import "NSObject+Concrete.h"
#import "UIDevice+Concrete.h"
#import "SKDocumentManager.h"
#import <sys/sysctl.h>

static BOOL _CILogOn = NO;
static BOOL _CIForwardLogToFile = NO;
static NSString* _CILogFileDirectory;
static NSString* _CICurrentLogFile;
static CILogger* _loggerInstance;

@interface CILogger()

@property (nonatomic, strong) NSFileHandle* fileHandle;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

@end

@implementation CILogger

+ (void)initialize
{
    // Set log file directory and current log file names
    _CILogFileDirectory = [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/LogFiles/"];
    _CICurrentLogFile = [_CILogFileDirectory stringByAppendingString:@"CurrentLogFile.txt"];
    
    // Setup from environment variables
	char* envLogOn = getenv("CILogOn");
    // Defaults to YES if no environment variable is set
	if (strcasecmp(envLogOn == NULL ? "YES" : envLogOn, "NO") != 0 &&
        strcasecmp(envLogOn == NULL ? "TRUE" : envLogOn, "FALSE") != 0 &&
        strcasecmp(envLogOn == NULL ? "1" : envLogOn, "0") != 0)
    {
		[CILogger setLogOn:YES];
    }
	char* envForwardingOn = getenv("CIForwardLogToFile");
    // Defaults to NO if no environment variable is set
	if (strcasecmp(envForwardingOn == NULL ? "NO" : envForwardingOn, "NO") != 0 &&
        strcasecmp(envForwardingOn == NULL ? "FALSE" : envForwardingOn, "FALSE") != 0 &&
        strcasecmp(envForwardingOn == NULL ? "0" : envForwardingOn, "0") != 0)
    {
		[CILogger setForwardLogToFileOn:YES];
    }
    
    // Create log file directory if it doesn't exist
    [CILogger createDirectoryAtPath:_CILogFileDirectory];
    
    // Create backup file directory if it doesn't exist
    [CILogger createDirectoryAtPath:[CILogger backupFileDirectoryPath]];
    
    // Clear any log file present and create a new one
    [[NSFileManager defaultManager] createFileAtPath:_CICurrentLogFile contents:nil attributes:nil];
}

+ (instancetype)sharedInstance
{
    if (_loggerInstance == nil)
    {
        _loggerInstance = [super sharedInstance];
    }
    return _loggerInstance;
}

+ (void)purgeSharedInstance
{
    _loggerInstance = nil;
    [super purgeSharedInstance];
}

+ (void)logWithSourceFile:(char *)sourceFile
               lineNumber:(int)lineNumber
            forwardToFile:(BOOL)forwardTofFile
                   format:(NSString *)format, ...
{
#ifndef DEBUG
    if (!_CIForwardLogToFile && !forwardTofFile)
    {
        return;
    }
#endif
	if(_CILogOn == NO)
    {
		return;
    }
	va_list ap;
	NSString *print, *file;
	va_start(ap, format);
	file = [[NSString alloc] initWithBytes:sourceFile
                                   length:strlen(sourceFile)
                                 encoding:NSUTF8StringEncoding];
	print = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
    
    NSString* logLine = [NSString stringWithFormat:@"%s:%d\n%@\n\n", [[file lastPathComponent] UTF8String], lineNumber, print];
    
#ifdef DEBUG
    //NSLog handles synchronization issues
	NSLog(@"%@", logLine);
#endif
    
    if (_CIForwardLogToFile || forwardTofFile)
    {
        logLine = [NSString stringWithFormat:@"%@ %@", [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"], logLine];
        
        if ([CILogger sharedInstance].fileHandle == nil)
        {
            [CILogger sharedInstance].operationQueue = [[NSOperationQueue alloc] init];
            [[CILogger sharedInstance].operationQueue setMaxConcurrentOperationCount:1];
            [[CILogger sharedInstance].operationQueue addOperationWithBlock:^{
                [CILogger sharedInstance].fileHandle = [NSFileHandle fileHandleForWritingAtPath:_CICurrentLogFile];
                [[CILogger sharedInstance].fileHandle seekToEndOfFile];
            }];
            NSString* systemInfo = [NSString stringWithFormat:@"%@ Version %@\n%@\niOS %@\n\n",
                                    [NSProcessInfo processInfo].processName,
                                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                    [[UIDevice currentDevice] userReadablePlatform],
                                    [NSProcessInfo processInfo].operatingSystemVersionString];
            [self saveFileUsingSK:systemInfo];
            [[CILogger sharedInstance].operationQueue addOperationWithBlock:^{
                [[CILogger sharedInstance].fileHandle writeData:[systemInfo dataUsingEncoding:NSUTF8StringEncoding]];
            }];
        }
        
        [[CILogger sharedInstance].operationQueue addOperationWithBlock:^{
            [[CILogger sharedInstance].fileHandle writeData:[logLine dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
	[self saveFileUsingSK:logLine];
	return;
}

+ (void)saveFileUsingSK:(NSString *)newLine
{
    SKDocumentManager* dm = [SKDocumentManager getInstance];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *path = [NSString stringWithFormat:@"%@%@.txt",[dm getLogDirectory],theDate];
    NSMutableDictionary *dic = nil;
    if ([dm fileExistsAtPath:path]) {
        dic = [[[SKDocumentManager getInstance] openFileAtPath:path] mutableCopy];
    } else {
        [dm createDirectoryAt:[dm getLogDirectory]];
        dic =  [[NSMutableDictionary alloc] init];
        [dic setObject:@"string" forKey:@"format"];
        [dic setObject:[NSString stringWithFormat:@"New Log File - %@\n",theDate] forKey:@"data"];
    }
    [dic setObject:[NSString stringWithFormat:@"%@%@\n",[dic objectForKey:@"data"],newLine] forKey:@"data"];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    for (id key in dic)
    {
        [archiver encodeObject:[dic objectForKey:key] forKey:key];
    }
    [archiver finishEncoding];
    NSError *error;
    [data writeToFile:path options:0 error:&error];
    //[dm saveDictionary:dic toFilePath:path];
    
}

+ (void)setLogOn:(BOOL)logOn
{
	_CILogOn = logOn;
}

+ (void)setForwardLogToFileOn:(BOOL)forwardOn
{
	_CIForwardLogToFile = forwardOn;
}

+ (void)backupLogFile
{
    [[CILogger sharedInstance].operationQueue addOperationWithBlock:^{
        [[CILogger sharedInstance].fileHandle closeFile];
        NSString* backupPath = [[CILogger backupFileDirectoryPath] stringByAppendingFormat:@"log_%@.txt", [[NSDate date] stringWithFormat:@"yyyy-MM-dd--HH-mm-ss.SSS"]];
        NSError* error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:_CICurrentLogFile toPath:backupPath error:&error];
        if (error)
        {
            if (_CILogOn)
            {
                CILog(@"%@", error);
#ifdef DEBUG
            } else {
                NSLog(@"%@", error);
#endif
            }
        }
        [CILogger sharedInstance].fileHandle = [NSFileHandle fileHandleForWritingAtPath:_CICurrentLogFile];
        [[CILogger sharedInstance].fileHandle seekToEndOfFile];
    }];
}

+ (NSString *)backupFileDirectoryPath
{
    return [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/SavedLogs/"];
}

+ (void)createDirectoryAtPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            if (_CILogOn)
            {
                CILog(@"%@", error);
#ifdef DEBUG
            } else {
                NSLog(@"%@", error);
#endif
            }
        }
    }
}

@end
