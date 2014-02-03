//
//  ZMTextHighlighter.m
//  Attributed String sandbox
//
//  Created by Jeff Wolski on 2/2/14.
//  Copyright (c) 2014 Zap Monkey LLC. All rights reserved.
//

#import "ZMTextHighlighter.h"
NSString *const ZMTextHighlighterException = @"ZMTextHighlighter Configuration Exception";

@interface ZMTextHighlighter()
@property (nonatomic, strong) NSArray *wordRanges;
@end
@implementation ZMTextHighlighter

#pragma mark - public methods

- (void)setTextHolder:(id<ZMTextHighlighterTextHolderProtocol>)textHolder{
    
    _textHolder = textHolder;
    _wordRanges = nil;
    
}

- (void)setPlainTextAttributes:(NSDictionary *)plainTextAttributes{
    _plainTextAttributes = plainTextAttributes;
    _wordRanges = nil;
}

- (void)setHighlightedTextAttributes:(NSDictionary *)highlightedTextAttributes{
    _highlightedTextAttributes = highlightedTextAttributes;
    _wordRanges = nil;
}

- (void)highlightCharacterRange:(NSRange)range{
    if (!_textHolder) {
        [NSException raise:ZMTextHighlighterException format:@"The textHolder property must be set before calling %s", __PRETTY_FUNCTION__];
    }
    // TODO: highlight charachters
    NSMutableAttributedString *newAttributedText = [self.textHolder.attributedText mutableCopy];
    NSRange fullRange = NSMakeRange(0, newAttributedText.string.length);
    [newAttributedText setAttributes:self.plainTextAttributes range:fullRange];
    
    [newAttributedText setAttributes:self.highlightedTextAttributes range:range];
    [newAttributedText fixAttributesInRange:fullRange];
    
    self.textHolder.attributedText = newAttributedText;
    
}

- (void)highlightWordRange:(NSRange)range{
    if (!_textHolder) {
        [NSException raise:ZMTextHighlighterException format:@"The textHolder property must be set before calling %s", __PRETTY_FUNCTION__];
    }
    
    NSUInteger firstCharacterLocation = [self.wordRanges[range.location] rangeValue].location;
    NSUInteger numberOfCharacters = 0;
    
    for (NSUInteger wordLocation = range.location; wordLocation < range.location + range.length; wordLocation++) {
        numberOfCharacters += [self.wordRanges[wordLocation] rangeValue].length;
    }
    
    [self highlightCharacterRange:NSMakeRange(firstCharacterLocation, numberOfCharacters)];
}

- (NSUInteger)wordCount{
    return self.wordRanges.count;
}
#pragma mark - private methods

- (NSArray *)wordRanges{
    if (!_wordRanges) {

        NSMutableArray *mutableResult = [[NSMutableArray alloc] init];
        CFStringRef string = (__bridge CFStringRef)(self.textHolder.attributedText.string);

        CFLocaleRef currentLocale = CFLocaleCopyCurrent();
        CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, string, CFRangeMake(0, CFStringGetLength(string)), kCFStringTokenizerUnitWord, currentLocale);

        CFStringTokenizerTokenType tokenType = kCFStringTokenizerTokenNone;
        unsigned tokenCount = 0;
        
        while(kCFStringTokenizerTokenNone != (tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)) ) {
            ++tokenCount;
            CFRange range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
            CFStringRef token = CFStringCreateWithSubstring(kCFAllocatorDefault, string, range);
            
            NSValue *rangeValue = [NSValue valueWithRange: NSMakeRange(range.location, range.length)];
            [mutableResult addObject:rangeValue];
            
            CFRelease(token);
        }

        _wordRanges = [mutableResult copy];
        CFRelease(tokenizer);
        CFRelease(currentLocale);

    }
    
    return _wordRanges;
}

@end
