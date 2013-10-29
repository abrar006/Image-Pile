//
//  ViewController.h
//  ImagePile
//
//  Created by Ibrar on 29/10/2013.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_COUNT 6

@interface ViewController : UIViewController < UIGestureRecognizerDelegate >{
    UIImageView *topImageView;
    
    NSArray *imageNumbers;
    int imageNum;
    int topImgNum, bottomImgNum;
    int image[IMAGE_COUNT];
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
