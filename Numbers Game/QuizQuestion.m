//
//  QuizQuestion.m
//  Numbers Game
//
//  Created by David Turissini on 8/2/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import "QuizQuestion.h"

@interface QuizQuestion ()

@end


@implementation QuizQuestion

@synthesize numCorrect, currentQuestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.correctColor = [UIColor colorWithRed:51.0 / 255.0 green:204.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    self.incorrectColor = [UIColor colorWithRed:204.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"numbers"
                                                     ofType:@"json"];
    
    
    NSData *data =  [NSData dataWithContentsOfFile:path];
    
    
    self.animationDuration = 0.2f;
    self.questionResultAnimationDuration = 0.4;
    NSError *jsonParsingError;
    self.questionsAnswers = (NSDictionary *)[NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:0
                                          error:&jsonParsingError];
    
    self.questions = [[NSMutableArray alloc] initWithArray:[self.questionsAnswers allKeys]];
    
    
    self.answersTable.delegate = self;
    self.answersTable.dataSource = self;
    self.answersTable.scrollEnabled = NO;
    
    
    CGSize size = self.questionResultView.frame.size;
    self.questionResultView.layer.borderWidth = 5.0f;
    self.questionResultView.layer.cornerRadius = size.width / 2;
    
    self.numQuestions = 10;
    numCorrect = 0;
    [self pickCurrentQuestions];
    [self nextQuestion];
    
}

- (void)pickCurrentQuestions {
    NSArray *possibleQuestions = [self shuffleArray:self.questions];
    NSRange range = NSMakeRange(0, self.numQuestions);
    self.currentQuestions = [possibleQuestions subarrayWithRange:range];
}


- (NSArray *) refreshAnswers:(NSString *) currentQuestion currentAnswer:(NSString *)currentAnswer {
    NSMutableArray *answers = [[NSMutableArray alloc] initWithObjects:currentAnswer, nil];
    int i = 0;
    NSArray *shuffledQuestions = [self shuffleArray:self.questions];
    
    while(answers.count < 4) {
        NSString *k = [shuffledQuestions objectAtIndex:i];
        
        if (k != currentQuestion) {
            [answers addObject:[self.questionsAnswers objectForKey:k]];
        }
        
        i += 1;
    }
    
    
    return [[NSArray alloc] initWithArray:[self shuffleArray:answers]];
}


- (void) nextQuestion {
    self.questionResultView.hidden = YES;
    self.question = [self.currentQuestions objectAtIndex:0];
    self.currentAnswer = (NSString *)[self.questionsAnswers objectForKey:self.question];
    
    
    NSRange range = NSMakeRange(1, self.currentQuestions.count - 1);
    self.currentQuestions = [self.currentQuestions subarrayWithRange:range];
    self.answers = [self refreshAnswers:self.question currentAnswer:self.currentAnswer];
    
    [self refreshViews];
    
}

- (void) refreshViews {
    self.questionText.text = self.question;
    
    [self.answersTable reloadData];
    [self animateTableCellsIn:^{
        [self animateQuestionLabelIn:^{
            
        }];
    }];
}

- (void)showResults {
    [self performSegueWithIdentifier:@"ShowQuizResults" sender:self];
    
}


- (NSArray *)shuffleArray:(NSArray *)array {
    NSMutableArray *shuffle = [[NSMutableArray alloc] initWithArray:array];
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [shuffle exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return [[NSArray alloc] initWithArray:shuffle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *answer = [self.answers objectAtIndex:indexPath.item];
    
    if (answer == self.currentAnswer) {
        numCorrect += 1;
        self.questionResultLabel.textColor = self.correctColor;
        self.questionResultView.layer.borderColor = self.correctColor.CGColor;
        self.questionResultLabel.text = @"✓";
    } else {
        self.questionResultLabel.text = @"✕";
        self.questionResultLabel.textColor = self.incorrectColor;
        self.questionResultView.layer.borderColor = self.incorrectColor.CGColor;
    }
    
    
    
    [self animateQuestionResultViewIn:^{
        [self handleAfterAnswerSelected];
    }];
    
    
}

- (void) animateQuestionLabelOut:(void(^)(void))animationComplete {
    UILabel *label = self.questionText;
    
    label.layer.transform = CATransform3DMakeTranslation(0, 0, 0);

    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:nil
                     animations:^{
                         
                         label.layer.transform = CATransform3DMakeTranslation(0, -self.answersTable.frame.size.height, 0);
                         label.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         animationComplete();
                         
                     }
     ];
}

- (void) animateQuestionLabelIn:(void(^)(void))animationComplete {
    UILabel *label = self.questionText;
    
    label.layer.transform = CATransform3DMakeTranslation(0, -self.answersTable.frame.size.height, 0);
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:nil
                     animations:^{
                         label.alpha = 1.0;
                         label.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
                     }
                     completion:^(BOOL finished) {
                         animationComplete();
                         
                     }
     ];
}

- (void) animateTableCellsIn:(void(^)(void))animationComplete {
    __block int numComplete = 0;
    NSArray *visibleCells = [self.answersTable visibleCells];
    float tableHeight = self.answersTable.frame.size.height;
    
    for(int i = 0; i < visibleCells.count; i += 1) {
        UITableViewCell *cell = [visibleCells objectAtIndex:i];
        cell.hidden = YES;
        cell.layer.transform = CATransform3DMakeTranslation(0, tableHeight, 0);
        
        
        [UIView animateWithDuration:self.animationDuration
                              delay:i * 0.1
                            options:nil
                         animations:^{
                             cell.hidden = NO;
                             cell.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
                         }
                         completion:^(BOOL finished) {
                             numComplete += 1;
                             
                             
                             if (numComplete < visibleCells.count) {
                                 return;
                             }
                             
                             animationComplete();
                             
                         }
         ];
    }
}


- (void)animateQuestionResultViewIn:(void(^)(void))animationComplete {
    UIView *view = self.questionResultView;
    
    view.layer.transform = CATransform3DMakeTranslation(0, 50, 0);
    view.alpha = 0.0;
    view.hidden = NO;
    
    [UIView animateWithDuration:self.questionResultAnimationDuration animations:^{
        
        self.questionResultView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        animationComplete();
    }];
    
}

- (void)animateQuestionResultViewOut:(void(^)(void))animationComplete {
    UIView *view = self.questionResultView;
    
    view.alpha = 1.0;
    
    [UIView animateWithDuration:self.questionResultAnimationDuration animations:^{
        view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        view.hidden = YES;
        animationComplete();
    }];
    
}

- (void) animateTableCellsOut:(void(^)(void))animationComplete {
    __block int numComplete = 0;
    NSArray *visibleCells = [self.answersTable visibleCells];
    float tableHeight = self.answersTable.frame.size.height;
    
    for(int i = 0; i < visibleCells.count; i += 1) {
        UITableViewCell *cell = [visibleCells objectAtIndex:i];
        
        [UIView animateWithDuration:self.animationDuration
                              delay:(visibleCells.count - i) * 0.1
                            options:nil
                         animations:^{
                             cell.layer.transform = CATransform3DMakeTranslation(0, tableHeight, 0);
                         }
                         completion:^(BOOL finished) {
                             numComplete += 1;
                             
                             cell.hidden = YES;
                             cell.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
                             
                             if (numComplete < visibleCells.count) {
                                 return;
                             }
                             
                             animationComplete();
                             
                         }
         ];
    }
}

- (void) handleAfterAnswerSelected {
    [self animateTableCellsOut:^{
        [self animateQuestionLabelOut:^{
            [self animateQuestionResultViewOut:^{
                if (self.currentQuestions.count > 0) {
                    [self nextQuestion];
                } else {
                    [self showResults];
                }
            }];
            
        }];
        
    }];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(QuizQuestion *)quizQuestion {
    if ([[segue identifier] isEqualToString:@"ShowQuizResults"]) {
        QuizResultsViewController *quizResults = (QuizResultsViewController *)[segue destinationViewController];
    
        quizResults.numCorrect = self.numCorrect;
        quizResults.numQuestions = self.numQuestions;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"AnswerCell";
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.hidden = YES;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    NSString *answer = [self.answers objectAtIndex:indexPath.item];
    NSNumber *answerNumber = [[NSNumber alloc] initWithLongLong:[answer longLongValue]];
    NSString *formattedOutput = [formatter stringFromNumber:answerNumber];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.text = formattedOutput;
    
    return cell;
    
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
