//
//  ViewController.m
//  FaceWarp
//
//  Created by Sreekanth on 28/04/15.
//  Copyright (c) 2015 FyrWeel. All rights reserved.
//

#import "ViewController.h"
#import "GalleryCollectionViewCell.h"
#import "EditorViewController.h"
#import "Model.h"

#define SEGUE_TO_EDITOR                 @"ImageListToEditor"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UICollectionView *faceWarpCollectionView;
    __weak IBOutlet UIButton *addButton;
    
    UIActionSheet *selectionSheet;
    
    NSMutableArray *imageArray;
    UIImage *imageForEditing;
    BOOL isEditing;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    addButton.layer.cornerRadius = 22.0;
    addButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchAllImages];
}

#pragma mark -Load From Documents Directory

- (void)fetchAllImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Model imagesDirectoryPath] error:nil];
        imageArray = [NSMutableArray array];
        for (id arrayElement in fileArray)
        {
            if ([arrayElement rangeOfString:@".png"].location != NSNotFound)
            {
                [imageArray addObject:arrayElement];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imageArray)
            {
                faceWarpCollectionView.dataSource = self;
                faceWarpCollectionView.delegate = self;
                [faceWarpCollectionView reloadData];
            }
        });
    });
}

#pragma mark -Import/Capture Image for editing

- (IBAction)addButtonPressed:(id)sender
{
    if (!selectionSheet)
    {
        selectionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    }
    [selectionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self imagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self imagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}

- (void)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark -Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageForEditing = info[UIImagePickerControllerOriginalImage];
    isEditing = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self performSegueWithIdentifier:SEGUE_TO_EDITOR sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -CollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCollectionViewCell" forIndexPath:indexPath];
    NSString *imagePath = [[Model imagesDirectoryPath] stringByAppendingPathComponent:[imageArray objectAtIndex:indexPath.row]];
    cell.faceWarpedImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imagePath = [[Model imagesDirectoryPath] stringByAppendingPathComponent:[imageArray objectAtIndex:indexPath.row]];
    imageForEditing = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    isEditing = NO;
    [self performSegueWithIdentifier:SEGUE_TO_EDITOR sender:self];
}

#pragma mark -Navigation Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_TO_EDITOR])
    {
        EditorViewController *editorViewController = (EditorViewController *)segue.destinationViewController;
        editorViewController.imageForEditing = imageForEditing;
        editorViewController.isEditing = isEditing;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
