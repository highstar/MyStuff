//
//  DetailViewController.m
//  MyStuff
//
//  Created by Gao Xing on 2018/8/1.
//  Copyright © 2018年 Gao Xing. All rights reserved.
//

#import "DetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface DetailViewController ()
{
    UIPopoverController *imagePopoverController;
}

@property (strong, nonatomic)UIPopoverController *masterPopoverController;

- (void)configureView;
- (void)presentmagePickerUsingCamera:(BOOL)useCamera;
- (void)dismissImagePicker;

@end

@implementation DetailViewController

- (void)presentImagePickerUsingCamera:(BOOL)useCamera
{
    imagePopoverController = nil;
    
    UIImagePickerController *cameraUI = [UIImagePickerController new];
    cameraUI.sourceType = (useCamera ? UIImagePickerControllerSourceTypeCamera
                           :UIImagePickerControllerSourceTypePhotoLibrary);
    cameraUI.mediaTypes = @[(NSString*)kUTTypeImage];
    cameraUI.delegate = self;
    if (useCamera || UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [self presentViewController:cameraUI animated:YES completion:nil];
    }
    else
    {
        imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:cameraUI];
        [imagePopoverController presentPopoverFromRect:self.imageView.frame
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.nameField.text = self.detailItem.name;
        self.locationField.text = self.detailItem.location;
        self.imageView.image = self.detailItem.viewImage;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (IBAction)changedDetail:(id)sender
{
    if (sender == self.nameField)
        self.detailItem.name = self.nameField.text;
    else if (sender == self.locationField)
        self.detailItem.location = self.locationField.text;
    
    [self.detailItem postDidChangedNotification];
}

- (IBAction)chosePicture:(id)sender
{
    [self dismissKeyboard:self];
    
    if (self.detailItem == nil)
        return;
    BOOL hasPhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera && !hasPhotoLibrary)
        return;
    if (hasPhotoLibrary && hasCamera)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take a Picture", @"Choose a Photo", nil];
        [actionSheet showInView:self.view];
        return;
    }
    [self presentImagePickerUsingCamera:hasCamera];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ((buttonIndex)) {
        case 0: // camera button
        case 1: // photo button
            [self presentImagePickerUsingCamera:(buttonIndex == 0)];
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
    {
        UIImage *whatsitImage = info[UIImagePickerControllerEditedImage];
        if (whatsitImage == nil)
            whatsitImage = info[UIImagePickerControllerOriginalImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            UIImageWriteToSavedPhotosAlbum(whatsitImage, nil, nil, nil);
        
        CGImageRef coreGraphicsImage = whatsitImage.CGImage;
        CGFloat height = CGImageGetHeight(coreGraphicsImage);
        CGFloat width = CGImageGetWidth(coreGraphicsImage);
        CGRect crop;
        if (height > width)
        {
            crop.size.height = crop.size.width = width;
            crop.origin.x = 0;
            crop.origin.y = floorf((height - width) / 2);
        }
        else
        {
            crop.size.height = crop.size.width = height;
            crop.origin.y = 0;
            crop.origin.x = floorf((width - height) / 2);
        }
        CGImageRef croppedImage = CGImageCreateWithImageInRect(coreGraphicsImage, crop);
        
        whatsitImage = [UIImage imageWithCGImage:croppedImage
                                           scale:MAX(crop.size.height/512, 1.0) orientation:whatsitImage.imageOrientation];
        CGImageRelease(croppedImage);
        
        _detailItem.image = whatsitImage;
        self.imageView.image = whatsitImage;
        [_detailItem postDidChangedNotification];
    }
    
    [self dismissImagePicker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}

- (void)dismissImagePicker
{
    if(imagePopoverController != nil)
    {
        [imagePopoverController dismissPopoverAnimated:YES];
        imagePopoverController = nil;
    }
    else
    {
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:NO];
}

@end
