//
//  AJImageheadData.m
//  yuanmeng
//
//  Created by 李春菲 on 16/10/10.
//  Copyright © 2016年 楚小亓. All rights reserved.
//

#import "AJImageheadData.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface AJImageheadData ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, copy) HHPickerCompelitionBlock completion;
@property (nonatomic, copy) HHPickerCancelBlock cancelBlock;


@end

@implementation AJImageheadData

#define kGlobalThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kMainThread dispatch_get_main_queue()
+(instancetype)shareInstance
{
    static AJImageheadData *dataHandel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHandel = [[AJImageheadData alloc] init];
    });
    return dataHandel;
}

- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                   completion:(HHPickerCompelitionBlock)completion
                  cancelBlock:(HHPickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    
    __weak typeof(self) VC = self;
    dispatch_async(kGlobalThread, ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:(id<UIActionSheetDelegate>)VC
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"拍照"
                                                        otherButtonTitles:@"从相册选择", nil];
        dispatch_async(kMainThread, ^{
            [actionSheet showInView:inView];
        });
    });
    return;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            [self clickTakingPictures];
            break;
        }
        case 1: {
            [self clickPhotoAlbum];
            break;
        }
        default:
            break;
    }
}

#pragma mark ------ 拍照
- (void)clickTakingPictures
{
    
    //判断当前相机的摄像头是否可用.这里SourceType有三个枚举值分别为
    /*
     UIImagePickerControllerSourceTypeCamera:照相机类型
     UIImagePickerControllerSourceTypeSavedPhotosAlbum：打开自定义图片库
     UIImagePickerControllerSourceTypePhotoLibrary：打开系统相册
     */
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //初始化照相机对象
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        //imagePC.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        
        //设置代理
        imagePC.delegate = self;
        //允许编辑
        imagePC.allowsEditing = YES;
        //指定使用照相机功能
        imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.fromController presentViewController:imagePC animated:YES completion:^{
            NSLog(@"进入拍照页面");
        }];
    } else {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"你当前的摄像头不可用" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark ------ 相册
- (void)clickPhotoAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc]init];
        imagePC.delegate = self;
        imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePC.allowsEditing = YES;
        //这个数组里面存放的有多少种类型，那么打开的相册里面就能看多什么类型的文件，例如：kUTTypeImage图片，kUTTypeMovie视频，kUTTypeMP3。mp3类型
        NSArray *array = [NSArray arrayWithObjects:(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie ,nil];
        
        //打开的多媒体类型
        imagePC.mediaTypes = array;
        [self.fromController presentViewController:imagePC animated:YES completion:^{
            
            NSLog(@"进入相册页面");
        }];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"相册打开失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma -mark选取相册中相片执行的方法
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //如果照片经过编辑之后，可以通过该方法获得
    __block UIImage *editImage = [info valueForKey:UIImagePickerControllerEditedImage];
    //如果是刚拍摄的照片就添加到相册中去
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //将照片保存到相册
        UIImageWriteToSavedPhotosAlbum(editImage, nil, nil,nil);
    }
    __weak typeof(self) weakSelf = self;
    if (editImage && self.completion) {
        dispatch_async(kGlobalThread, ^{
            // 设置image的尺寸
            CGSize imageSize = editImage.size;
            imageSize.height = 100;
            imageSize.width = 100;
            
            // 对图片大小进行压缩
            editImage = [weakSelf imageWithImage:editImage scaledToSize:imageSize];

            // 把图片转成data
            NSData *data;
            if (!UIImagePNGRepresentation(editImage)) {
                data = UIImageJPEGRepresentation(editImage, 0.0001);
                [weakSelf setupCompletionWithImage:editImage data:data];
            } else {
                data = UIImagePNGRepresentation(editImage);
                [weakSelf setupCompletionWithImage:editImage data:data];
            }
        });
    }
    return;
}

- (void)setupCompletionWithImage:(UIImage *)image data:(NSData *)data {
    dispatch_async(kMainThread, ^{
        self.completion(image, data);
    });
}

// 对图片尺寸进行压缩
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    return;
}


@end
