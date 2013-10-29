//
//  ViewController.m
//  ImagePile
//
//  Created by Ibrar on 29/10/2013.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    for (int i = 0; i< IMAGE_COUNT ; i++){
        image[i] = i+1;
    }
    imageNum = 0;
    [self handlePile];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)handlePile{
    topImgNum = imageNum % IMAGE_COUNT;
    bottomImgNum = (topImgNum+1) % IMAGE_COUNT;
    [self addTopImageWithImageName:[NSString stringWithFormat:@"image%d.jpeg", topImgNum]];
    [self setBottomImageWithImageName:[NSString stringWithFormat:@"image%d.jpeg", bottomImgNum]];
}

-(void)addTopImageWithImageName:(NSString*)imageNmae{
    topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNmae] highlightedImage:[UIImage imageNamed:imageNmae]];
    [topImageView setUserInteractionEnabled:YES];
    [topImageView setFrame:CGRectMake(35, 160, 250, 250)];
    [self.view addSubview:topImageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelegate:self];
    [panGesture setMaximumNumberOfTouches:1];
    [topImageView addGestureRecognizer:panGesture];
}

-(void)setBottomImageWithImageName:(NSString*)imageName{
    [_imageView setImage:[UIImage imageNamed:imageName]];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    float halfHiehgt = recognizer.view.frame.size.height/2;
    
    CGPoint loc = [recognizer locationInView:recognizer.view];
    
    CGPoint vel = [recognizer velocityInView:self.view];
    
    CGFloat radians = atan2f(recognizer.view.transform.b, recognizer.view.transform.a);
   
    
    if(loc.y <= halfHiehgt){
        if (vel.x > 0){ // user dragged from Top Right corner
            if(radians >= -0.50 ){
                recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, -0.01);
            }
        }else{  // user dragged from Top Left corner
            if(radians <= 0.50 ){
                recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, 0.01);
            }
        }
    }else{
        if (vel.x > 0){ // user dragged from Bottom Right corner
            if(radians <= 0.50 ){
                recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, 0.01);
            }
        }else{  // user dragged from Bottom Left corner
            if(radians >= -0.50 ){
                recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, -0.01);
            }
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        CGPoint loc = recognizer.view.center;
        CGRect area = CGRectMake(85, 210, 150, 150);
        if(CGRectContainsPoint(area, loc)) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center = CGPointMake(160, 285);
                recognizer.view.transform = CGAffineTransformMakeRotation(0);
                
            } completion:nil];
        }else{
            
            CGPoint velocity = [recognizer velocityInView:self.view];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            CGFloat slideMult = magnitude / 200;
            NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
            
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                             recognizer.view.center.y + (velocity.y * slideFactor));
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
            
            [UIView animateWithDuration:slideFactor delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center = finalPoint;
                recognizer.view.alpha = 0.0;
            } completion:^(BOOL fin) {
                if (fin){
                    [recognizer.view removeFromSuperview];
                }
                
            }];

            imageNum = imageNum + 1;
            [self handlePile];
            
        }
    }
    
}

@end
