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
    
    NSString *resultsString = [NSString stringWithFormat:@"You got %d out of %d correct",
                               self.numCorrect,
                               self.numQuestions
                               ];
    
    self.badgeStrings = [[NSArray alloc] initWithObjects:
                         @"Congratulations! You definitely know your numbers!",
                         @"You know your numbers, but you could know more!",
                         @"Keep trying!",
                         nil
                         ];
    float percentCorrect = ((float)self.numCorrect / (float)self.numQuestions);
    
    self.badgeLabel.text = [self getBadgeLabelText:percentCorrect];
    
    self.resultsLabel.text = resultsString;
}

- (NSString *) getBadgeLabelText:(float)percentCorrect {
    
    int badgeIndex = 2;
    
    if (percentCorrect >= 0.8f) {
        badgeIndex = 0;
    } else if (percentCorrect >= 0.4f) {
        badgeIndex = 1;
    }
    
    NSString *str = (NSString *)[self.badgeStrings objectAtIndex:badgeIndex];
    
    return str;
    
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
