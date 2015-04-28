//
//  EditorViewController.m
//  FaceWarp
//
//  Created by Sreekanth on 28/04/15.
//  Copyright (c) 2015 FyrWeel. All rights reserved.
//

#import "EditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "Model.h"

@interface EditorViewController ()
{
    __weak IBOutlet UIImageView *editorImageView;
}

@end

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    editorImageView.image = _imageForEditing;
    if (_isEditing)
    {
        [self markFace];
    }
}

- (void)saveImage
{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMddyyyy_HHmmssSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString *savedImagePath = [[Model imagesDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"FW_%@.png", dateString]];
    UIImage *image = editorImageView.image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}

- (void)setImageForEditing:(UIImage *)imageForEditing
{
    _imageForEditing = imageForEditing;
}

- (void)markFace
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *editedImage = _imageForEditing;
        for (CIFaceFeature *faceFeature in [self getFeaturesForImage:_imageForEditing])
        {
            if (faceFeature.hasLeftEyePosition)
            {
                CGRect leftEyeFrame = CGRectMake((faceFeature.leftEyePosition.x - (faceFeature.bounds.size.width * 0.1)), (faceFeature.leftEyePosition.y - (faceFeature.bounds.size.height * 0.23)), (faceFeature.bounds.size.width * 0.20), (faceFeature.bounds.size.width * 0.20));
                
                editedImage = [self drawImage:editedImage withFeature:[UIImage imageNamed:@"funny_eye_1"] inFrame:leftEyeFrame];
                dispatch_async(dispatch_get_main_queue(), ^{
                    editorImageView.image = editedImage;
                });
            }
            if (faceFeature.hasRightEyePosition)
            {
                CGRect rightEyeFrame = CGRectMake((faceFeature.rightEyePosition.x - (faceFeature.bounds.size.width * 0.1)), (faceFeature.rightEyePosition.y - (faceFeature.bounds.size.height * 0.23)), (faceFeature.bounds.size.width * 0.20), (faceFeature.bounds.size.width * 0.20));
                
                editedImage = [self drawImage:editedImage withFeature:[UIImage imageNamed:@"funny_eye_1"] inFrame:rightEyeFrame];
                dispatch_async(dispatch_get_main_queue(), ^{
                    editorImageView.image = editedImage;
                });
            }
        }
    });
}

- (NSArray *)getFeaturesForImage:(UIImage *)faceImage
{
    CIImage *face = [CIImage imageWithCGImage:faceImage.CGImage];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    return [faceDetector featuresInImage:face];
}

-(UIImage *)drawImage:(UIImage*)faceImage withFeature:(UIImage *)featureImage inFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(faceImage.size, NO, 0.0f);
    [faceImage drawInRect:CGRectMake(0, 0, faceImage.size.width, faceImage.size.height)];
    [featureImage drawInRect:frame];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
