//
//  CameraViewController.m
//  Test
//
//  Created by Purpose Code on 04/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController (){
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    NSInteger imageLimit;
    NSMutableArray *arrImages;
    NSTimer *timer;
    NSInteger curentTime;
    NSInteger burstTime;
    
    IBOutlet UILabel *lblTimeInfo;
    IBOutlet UIView *vwOverLay;
    IBOutlet UIView *vwImgBg;
    IBOutlet UIButton *btnTakePicture;
    
    
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialiseViews];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
   [self setUp];
   [self setupCaptureSession];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [self resetControlls];
}

-(void)initialiseViews{
    vwOverLay.hidden = true;
    vwImgBg.hidden = true;
}

-(void)setUp{
    
    imageLimit = 4;
    curentTime = 5;
    burstTime = 5;
    vwImgBg.hidden = true;
    lblTimeInfo.hidden = true;
    arrImages = [NSMutableArray  new];
    btnTakePicture.layer.cornerRadius = 25;
    btnTakePicture.layer.borderWidth = 1.f;
    btnTakePicture.layer.borderColor = [UIColor clearColor].CGColor;
    lblTimeInfo.text = [NSString stringWithFormat:@"%d",curentTime];
    btnTakePicture.hidden = false;
    vwOverLay.hidden = false;
    
}

/////////////////////////////////////////////////
////
//// Utility to find front camera
////
/////////////////////////////////////////////////
-(AVCaptureDevice *) frontFacingCameraIfAvailable{
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *device in videoDevices){
        
        if (device.position == AVCaptureDevicePositionFront){
            
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if (!captureDevice){
        
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

/////////////////////////////////////////////////
////
//// Setup Session, attach Video Preview Layer
//// and Capture Device, start running session
////
/////////////////////////////////////////////////
-(void) setupCaptureSession {
    
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    NSError *error = nil;
    AVCaptureDevice *device = [self frontFacingCameraIfAvailable];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [session addOutput:stillImageOutput];
    [session startRunning];
    [self.view bringSubviewToFront:vwOverLay];
}


/////////////////////////////////////////////////
// Method to capture Still Image from
/////////////////////////////////////////////////


-(IBAction)captureNow {
    
    btnTakePicture.hidden = true;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    __weak typeof(self) weakSelf = self;
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [arrImages addObject:image];
        [weakSelf displayImage:image];
        if (arrImages.count == imageLimit){
            [self resetControlls];
            [Utility saveSelectedImageFileToFolderWith:[self getCombinedImage]];
            
        }
    }];
    
    if (!timer) {
        lblTimeInfo.hidden = false;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(startCountDown)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)startCountDown {
    
    if (arrImages.count == imageLimit) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    lblTimeInfo.text = [NSString stringWithFormat:@"%d",curentTime];
    curentTime --;
    if (curentTime == 0) {
        [self captureNow];
        curentTime = 5;
    }
    
    
}


-(void)displayImage:(UIImage*)image{
    
    if (arrImages.count) {
        if ([vwImgBg viewWithTag:arrImages.count]) {
            UIImageView *imgView = (UIImageView*) [vwImgBg viewWithTag:arrImages.count];
            [imgView setImage:[arrImages lastObject]];
        }
    }
}

-(void)resetControlls{
    
    vwOverLay.hidden = true;
    vwImgBg.hidden = false;
    [session stopRunning];
    [captureVideoPreviewLayer removeFromSuperlayer];
    btnTakePicture.hidden = false;
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
}

-(UIImage*)getCombinedImage{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(vwImgBg.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(vwImgBg.bounds.size);
    
    [vwImgBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}




- (void)didReceiveMemoryWarning {
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
