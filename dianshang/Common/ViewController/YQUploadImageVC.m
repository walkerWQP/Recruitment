//
//  YQUploadImageVC.m
//  kuainiao
//
//  Created by yunjobs on 16/8/23.
//  Copyright © 2016年 yunjobs. All rights reserved.
//  继承这个类就有了选择图片的方法

#import "YQUploadImageVC.h"
#import "YSHYClipViewController.h"
#import "JurisdictionMethod.h"

@interface YQUploadImageVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ClipViewControllerDelegate>
{
    //NSInteger headViewTag;
}
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, assign) YQImageClipType yqClipType;

@end

@implementation YQUploadImageVC

- (MBProgressHUD *)slideView
{
    if (_slideView == nil) {
        _slideView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _slideView.mode = MBProgressHUDModeAnnularDeterminate;
        _slideView.labelText = @"正在上传...";
        [self.view addSubview:_slideView];
    }
    return _slideView;
}

//打开选择图片的UIActionSheet
- (void)openActionSheet:(YQImageClipType)tag
{
    self.yqClipType = tag;
    
    UIActionSheet *myActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库选取", nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        //判断是否具有相机权限
        if ([JurisdictionMethod videoJurisdiction]) {
            //打开照相机拍照
            [self takePhoto];
        }else{
            [[JurisdictionMethod shareJurisdictionMethod] photoJurisdictionAlert];
        }
    }else if (buttonIndex==1) {
        //判断是否具有相机权限
        if ([JurisdictionMethod libraryJurisdiction]) {
            //打开图库
            [self LocalPhoto];
        }else{
            [[JurisdictionMethod shareJurisdictionMethod] libraryJurisdictionAlert];
        }
    }
    
}
//打开照相机
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker=[[UIImagePickerController alloc] init];
        self.imagePicker.delegate=self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        CLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
}

///打开本地图库
-(void)LocalPhoto{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    self.picker.allowsEditing=NO;
    UINavigationBar *navbar = self.picker.navigationBar;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    navbar.titleTextAttributes = mDict;
    [navbar setTintColor:[UIColor whiteColor]];
    [navbar setBarTintColor:THEMECOLOR];
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

////把选中的图片放到这里
-(void)imagePickerController:(UIImagePickerController *)pickera didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        //CLog(@"-------------a-------------");
        UIImage *originImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (originImage == nil) {
            originImage = info[UIImagePickerControllerOriginalImage];
        }
        [self imageHandleOperation:pickera image:originImage];
    }
    //改变状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/*!
 *  @brief 图片剪裁业务处理逻辑
*/
- (void)imageHandleOperation:(UIImagePickerController *)pickera image:(UIImage *)originImage
{
    if (self.isClip) {//需要裁剪图片
        
        CGSize clipSize = CGSizeZero;
        if (self.yqClipType == YQClipTypeSquare) {
            //头像剪裁成方形
            clipSize = CGSizeMake(APP_WIDTH, APP_WIDTH);
        }else{
            //门头照剪裁成长方形
            clipSize = CGSizeMake(APP_WIDTH, APP_WIDTH*0.55);
        }
        //执行剪切
        YSHYClipViewController *clipView = [[YSHYClipViewController alloc] initWithImage:originImage];
        clipView.clipType = SQUARECLIP;//方形剪裁
        clipView.rectSize = clipSize;
        clipView.delegate = self;
        [pickera pushViewController:clipView animated:YES];
    }else{//不需要裁剪
        [self imageUploadHandle:originImage];
    }
}

- (void)imageUploadHandle:(UIImage *)editImage
{
    // 伸缩图片
    UIImage *theImage = [self imageCompressForWidth:editImage targetWidth:APP_WIDTH];
    //保存图像
//    NSString *filePath = [self saveImage:theImage WithName:[NSString stringWithFormat:@"headimg.png"]];
    //设置图片
    [self uploadImage:theImage filePath:@""];
}

//在这个方法里上传照片需要继承者重写
- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath
{
    //在这个方法里上传照片需要继承者重写
    
}
/*!
 *  @author 15-07-07 10:07:15
 *
 *  @brief  存储图片到沙盒
 *
 *  @param tempImage 图像信息
 *  @param imageName 图像保存的名称
 */
- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - ClipViewControllerDelegate

/*!
 *  @brief 剪裁图片回调
 */
- (void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
    [self imageUploadHandle:editImage];
}

#pragma mark - ImagePickerDelegate
/**
 *	@brief	代理-取消选择
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //改变状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
