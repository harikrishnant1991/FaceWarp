//
//  Model.h
//  FaceWarp
//
//  Created by Sreekanth on 28/04/15.
//  Copyright (c) 2015 FyrWeel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (NSString *)imagesDirectoryPath;

+ (Model *)sharedInstance;

@end
