//
//  CILog.m
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/27/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#import "CILogger.h"
#import "NSDate+Concrete.h"

static BOOL _CILogOn = NO;
static BOOL _CIForwardLogToFile = NO;
static NSMutableArray* _CIFileLogWriteQueue;
static NSString* _CILogFileDirectory;
static NSString* _CICurrentLogFile;

@implementation CILogger

+ (void)initialize
{
    // Set log file directory and current log file names
    _CILogFileDirectory = [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/LogFiles/"];
    _CICurrentLogFile = [_CILogFileDirectory stringByAppendingString:@"CurrentLogFile.txt"];
    
    // Setup from environment variables
	char* envLogOn = getenv("CILogOn");
	if (strcmp(envLogOn == NULL ? "" : envLogOn, "NO") != 0)
    {
		[CILogger setLogOn:YES];
    }
	char* envForwardingOn = getenv("CIForwardLogToFile");
	if (strcmp(envForwardingOn == NULL ? "" : envForwardingOn, "NO") != 0)
    {
		[CILogger setForwardLogToFileOn:YES];
    }
    
    // Setup file log buffer
    _CIFileLogWriteQueue = [NSMutableArray arrayWithCapacity:50];
    
    // Create log file directory if it doesn't exist
    if (![[NSFileManager defaultManager] fileExistsAtPath:_CILogFileDirectory])
    {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:_CILogFileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
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
    
    // Clear any log file present and create a new one
    [[NSFileManager defaultManager] createFileAtPath:_CICurrentLogFile contents:nil attributes:nil];
}

+ (void)logWithSourceFile:(char *)sourceFile
               lineNumber:(int)lineNumber
            forwardToFile:(BOOL)forwardTofFile
                   format:(NSString *)format, ...
{
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
    
    NSString* logLine = [NSString stringWithFormat:@"\n%s:%d %@", [[file lastPathComponent] UTF8String], lineNumber, print];
    
#ifdef DEBUG
    //NSLog handles synchronization issues
	NSLog(@"%@", logLine);
#endif
    
    if (_CIForwardLogToFile || forwardTofFile)
    {
        [_CIFileLogWriteQueue addObject:logLine];
    }
	
	return;
}

+ (void)setLogOn:(BOOL)logOn
{
	_CILogOn = logOn;
}

+ (void)setForwardLogToFileOn:(BOOL)forwardOn
{
	_CIForwardLogToFile = forwardOn;
}

+ (void)saveToFileFromQueue
{
    NSArray* remainingLines = [NSArray arrayWithArray:_CIFileLogWriteQueue];
    [_CIFileLogWriteQueue removeAllObjects];
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_CICurrentLogFile];
    [fileHandle seekToEndOfFile];
    for (NSString* logLine in remainingLines)
    {
        [fileHandle writeData:[logLine dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [fileHandle closeFile];
}

+ (void)backupLogFile
{
    [self saveToFileFromQueue];
    NSString* backupPath = [_CILogFileDirectory stringByAppendingFormat:@"log_%@.txt", [[NSDate date] stringWithFormat:@"yyyy-MM-dd--HH-mm-ss"]];
    NSError* error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:_CICurrentLogFile toPath:backupPath error:&error];
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




//- (NSString *)rootDirectory
//{
//    if (_rootDirectory == nil)
//    {
//        self.rootDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    }
//    return _rootDirectory;
//}
//
//- (BOOL)fileExistsAtPath:(NSString *)path
//{
//    return [[NSFileManager defaultManager] fileExistsAtPath:path];
//}
//
//- (BOOL)deleteFileAt:(NSString *)path
//{
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//    {
//        NSError* error = nil;
//        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//#ifdef DEBUG
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//#endif
//        return result;
//    }
//    return TRUE;
//}
//
//- (void)backupFileAtPath:(NSString *)path
//{
//    NSString* file = [[path componentsSeparatedByString:@"/"] lastObject];
//    NSString* fileName = [[file componentsSeparatedByString:@"."] firstObject];
//    NSString* extention = [[file componentsSeparatedByString:@"."] lastObject];
//    SKLoggedInCamperArray* camperArray = [SKLoggedInCamperArray sharedInstance];
//    for (SKCamper* camper in camperArray)
//    {
//        int i = 0;
//        NSString* backupPath = nil;
//        do {
//            i++;
//            backupPath = [NSString stringWithFormat:@"%@/%@~camper_%@_file_%d.%@", [[SKDocumentManager sharedInstance] getBackupDirectory], fileName, camper.idNumber, i, extention];
//        } while ([[NSFileManager defaultManager] fileExistsAtPath:backupPath]);
//        NSError* error = nil;
//        if (camper == [camperArray lastCamper])
//        {
//            [[NSFileManager defaultManager] moveItemAtPath:path toPath:backupPath error:&error];
//        } else {
//            [[NSFileManager defaultManager] copyItemAtPath:path toPath:backupPath error:&error];
//        }
//#ifdef DEBUG
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//#endif
//    }
//}

@end
