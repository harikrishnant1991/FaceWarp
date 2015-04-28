//
//  Model.m
//  FaceWarp
//
//  Created by Sreekanth on 28/04/15.
//  Copyright (c) 2015 FyrWeel. All rights reserved.
//

#import "Model.h"

#define FACE_WARPED_IMAGES_DIRECTORY    @"FaceWarpedImages"

@implementation Model

+ (Model *)sharedInstance
{
    static Model *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (NSString *)imagesDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", FACE_WARPED_IMAGES_DIRECTORY]];
    BOOL isDirectory;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDirectory] && isDirectory))
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error)
        {
            return nil;
        }
        
    }
    return dataPath;
}

@end
