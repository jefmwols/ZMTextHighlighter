//
//  ZMTextHighlighter.h
//  Attributed String sandbox
//
//  Created by Jeff Wolski on 2/2/14.
//  Copyright (c) 2014 Zap Monkey LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ZMTextHighlighterTextHolderProtocol <NSObject>

@property NSAttributedString *attributedText;

@end

/**
 * ZMTextHighlighter is used for highlighting NSAttributedStrings in UI elements.
 */
@interface ZMTextHighlighter : NSObject

/**
 An object that owns the NSAttributedString to be highlighted.
 This is usually a UITextField, UITextView, UILabel, etc.
 */
@property (nonatomic, weak) id<ZMTextHighlighterTextHolderProtocol> textHolder;

/**
 NSDictionary that contains the attributes for the plain text
 */
@property (strong, nonatomic) NSDictionary *plainTextAttributes;

/**
 NSDictionary that contains the attributes for the highlighted text
 */
@property (strong, nonatomic) NSDictionary *highlightedTextAttributes;

/**
 * Highlights the characers in the specified range
 *
 @param range  NSRange specifying the first character and number of characters to be highlighted
 @returns void
 */
-(void) highlightCharacterRange:(NSRange) range;

/**
 * Highlights the words in the specified range
 *
 @param range  NSRange specifying the first word and number of words to be highlighted
 @returns void
 */
-(void) highlightWordRange:(NSRange) range;

- (NSUInteger) wordCount;
@end
