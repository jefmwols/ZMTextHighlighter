//
//  ZMViewController.m
//  ZMTextHighlighter Example
//
//  Created by Jeff Wolski on 2/2/14.
//  Copyright (c) 2014 Zap Monkey LLC. All rights reserved.
//

#import "ZMViewController.h"
#import "ZMTextHighlighter.h"

#define kNumberOfWordsToHighlight 1

@interface ZMViewController ()
@property (weak, nonatomic) IBOutlet UITextView<ZMTextHighlighterTextHolderProtocol> *textView;
@property (nonatomic, strong) ZMTextHighlighter* textHighlighter;
@property (nonatomic, assign) NSUInteger currentWord;

@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textHighlighter = [[ZMTextHighlighter alloc] init];
    self.textHighlighter.textHolder = self.textView;
    self.textHighlighter.plainTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:45]};
    self.textHighlighter.highlightedTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:45]};

    [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(highlightNextWord) userInfo:nil repeats:YES];
    
}

- (void) highlightNextWord {
    
    // make sure we don't try to highlight past the end of the string
    if (self.currentWord + kNumberOfWordsToHighlight > self.textHighlighter.wordCount) {
        self.currentWord = 0;
    }
    
    [self.textHighlighter highlightWordRange:NSMakeRange(self.currentWord, kNumberOfWordsToHighlight)];
    
    self.currentWord++;
}

@end
