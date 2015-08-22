//
//  QuizResultsViewController.m
//  Numbers Game
//
//  Created by David Turissini on 8/8/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import "QuizResultsViewController.h"

@interface QuizResultsViewController ()

@end

@implementation QuizResultsViewController
@synthesize numCorrect, numQuestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *resultsString = [NSString stringWithFormat:@"You got %d out of %d correct!",
                               self.numCorrect,
                               self.numQuestions
                               ];

    self.resultsLabel.text = resultsString;
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
