//
//  CILogger.h
//  ConcreteFoundation
//
//  Created by Joshua Dudley on 5/27/14.
//  Copyright (c) 2014 Concrete Interactive. All rights reserved.
//

#define CILog(s,...) [CILogger logWithSourceFile:__FILE__ lineNumber:__LINE__ forwardToFile:NO format:(s),##__VA_ARGS__]
#define CIFileLog(s,...) [CILogger logWithSourceFile:__FILE__ lineNumber:__LINE__ forwardToFile:YES format:(s),##__VA_ARGS__]

@interface CILogger : NSObject

+ (void)logWithSourceFile:(char*)sourceFile
               lineNumber:(int)lineNumber
            forwardToFile:(BOOL)forwardTofFile
                   format:(NSString*)format, ...;

+ (void)setLogOn:(BOOL)logOn;
+ (void)setForwardLogToFileOn:(BOOL)forwardOn;
+ (void)backupLogFile;
+ (NSString *)backupFileDirectoryPath;

@end
