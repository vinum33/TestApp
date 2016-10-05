//
//  MapDisplayViewController.m
//  Test
//
//  Created by Purpose Code on 04/10/16.
//  Copyright © 2016 Purpose Code. All rights reserved.
//

#import "MapDisplayViewController.h"
#import "Constants.h"

@import GoogleMaps;

@interface MapDisplayViewController () <GMSMapViewDelegate>{
    
    IBOutlet GMSMapView *_mapView;
    NSArray *arrLocations;
}

@end

@implementation MapDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self loadAllAnnotations];
    // Do any additional setup after loading the view.
}

-(void)setUp{
    
    _mapView.mapType = kGMSTypeSatellite;
    _mapView.delegate = self;
     NSDictionary *locOne = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:9.931233],@"latitude",[NSNumber numberWithFloat:76.267304],@"longitude",StaticImageURL,@"imageURL", nil];
     NSDictionary *locTwo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:8.524139],@"latitude",[NSNumber numberWithFloat:76.936638],@"longitude",StaticImageURL,@"imageURL", nil];
     NSDictionary *locThree = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:11.874477],@"latitude",[NSNumber numberWithFloat:75.370366],@"longitude",StaticImageURL,@"imageURL", nil];
     NSDictionary *locFour = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:11.703206],@"latitude",[NSNumber numberWithFloat:76.083400],@"longitude",StaticImageURL,@"imageURL", nil];
     NSDictionary *locFive = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:11.258753],@"latitude",[NSNumber numberWithFloat:75.780410],@"longitude",StaticImageURL,@"imageURL", nil];
    arrLocations = [[NSArray alloc] initWithObjects:locOne,locTwo,locThree,locFour,locFive, nil];
}

-(void)loadAllAnnotations{
    
    for (NSDictionary *dict in arrLocations) {
        
        float latitdue = 0.0;
        float longitude = 0.0;
        
        if (dict && [dict objectForKey:@"latitude"])
            latitdue = [[dict objectForKey:@"latitude"]floatValue];
        if (dict && [dict objectForKey:@"longitude"])
            longitude = [[dict objectForKey:@"longitude"]floatValue];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.position =  CLLocationCoordinate2DMake(latitdue, longitude);
        marker.map = _mapView;
        marker.tappable = YES;
        marker.userData = @{@"imageURL": [dict objectForKey:@"imageURL"] };
        marker.draggable = NO;
        _mapView.accessibilityElementsHidden = NO;
        marker.zIndex = 1;
        
    }
    [self focusMapToShowAllMarkers:arrLocations];

}

- (void)focusMapToShowAllMarkers:(NSArray*)_markers;
{
    
    NSDictionary *dict  = _markers[0];
    CLLocationDegrees latitude = [dict[@"latitude"] doubleValue];
    CLLocationDegrees longitude = [dict[@"longitude"] doubleValue];
    
    CLLocationCoordinate2D myLocation = CLLocationCoordinate2DMake(latitude, longitude);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for ( NSDictionary *dict  in _markers){
        
        CLLocationDegrees latitude = [dict[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [dict[@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        bounds = [bounds includingCoordinate:coordinates];
    }
    
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:100.0f]];
}

#pragma mark - Map Deleagte

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
}

- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
     NSDictionary *markerInfo = marker.userData;
    if (markerInfo && [markerInfo objectForKey:@"imageURL"]) {
        return [self createMarkerInfoWindowWithImage:[markerInfo objectForKey:@"imageURL"]];
    }
    return nil;
   
}

#pragma mark - Generic Methods

-(UIView*)createMarkerInfoWindowWithImage:(NSString*)strURL{
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, 100, 100);
    bgView.backgroundColor = [UIColor blackColor];
    
    // Async loading image
    
    UIImageView *imgView = [UIImageView new];
    imgView.frame = bgView.frame;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strURL]
                          placeholderImage:[UIImage imageNamed:@"NoImage.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                 }];
    return bgView;
    
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
