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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"numbers"
                                                     ofType:@"json"];
    
    
    NSData *data =  [NSData dataWithContentsOfFile:path];
    
    
    
    NSError *jsonParsingError;
    self.questionsAnswers = (NSDictionary *)[NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:0
                                          error:&jsonParsingError];
    
    self.questions = [[NSMutableArray alloc] initWithArray:[self.questionsAnswers allKeys]];
    
    
    self.answersTable.delegate = self;
    self.answersTable.dataSource = self;
    self.answersTable.scrollEnabled = NO;
    
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
    }
    
    if (self.currentQuestions.count > 0) {
        [self nextQuestion];
    } else {
        [self showResults];
    }
    
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
