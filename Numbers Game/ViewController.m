//
//  ViewController.m
//  Numbers Game
//
//  Created by David Turissini on 8/2/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self animateNumbers];

}

- (void) animateNumbers {
    int viewWidth = self.numbersAnimation.frame.size.width;
    
    [UIView animateWithDuration:60
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.numbersAnimation.layer.transform = CATransform3DMakeTranslation(-viewWidth, 0, 0);
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
