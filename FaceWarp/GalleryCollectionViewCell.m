//
//  GalleryCollectionViewCell.m
//  FaceWarp
//
//  Created by Sreekanth on 28/04/15.
//  Copyright (c) 2015 FyrWeel. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

@interface GalleryCollectionViewCell ()
{
    __weak IBOutlet UIImageView *faceWarpImageView;
}

@end

@implementation GalleryCollectionViewCell

- (void)setFaceWarpedImage:(UIImage *)faceWarpedImage
{
    faceWarpImageView.image = faceWarpedImage;
}

@end
