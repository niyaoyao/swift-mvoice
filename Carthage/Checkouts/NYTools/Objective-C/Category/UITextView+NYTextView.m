//
//  UITextView+NYTextView.m
//  NYDiaryOC
//
//  Created by NiYao on 4/25/16.
//  Copyright © 2016 niyao. All rights reserved.
//

#import "UITextView+NYTextView.h"
#import <objc/runtime.h>

static const char *placeholderLabelKey = "placeholderLabel";
static const char *textViewActionKey   = "textViewAction";

@interface UITextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel          *placeholderLabel;
@property (nonatomic, copy  ) NYTextViewAction textViewAction;

@end

@implementation UITextView (NYTextView)

#pragma mark - Property

- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, placeholderLabelKey);
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, placeholderLabelKey, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NYTextViewAction)textViewAction {
    return objc_getAssociatedObject(self, textViewActionKey);
}

- (void)setTextViewAction:(NYTextViewAction)textViewAction {
    objc_setAssociatedObject(self, textViewActionKey, textViewAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeShouldBeginEditing);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeShouldEndEditing);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeDidBeginEditing);
    }
    self.placeholderLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeDidEndEditing);
    }
    self.placeholderLabel.hidden = (textView.text.length == 0) ?
    NO : YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeShouldChangeTextInRange);
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeDidChange);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeDidChangeSelection);
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeShouldInteractWithURL);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if (self.textViewAction != nil) {
        self.textViewAction(NYTextViewActionTypeShouldInteractWithTextAttachment);
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)setupPlaceholderString:(NSString *)placeholderString frame:(CGRect)frame {
    UILabel *placeholderLabel  = [[UILabel alloc] initWithFrame:frame];
    placeholderLabel.text      = placeholderString;
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.frame     = frame;
    placeholderLabel.font      = self.font;
    self.placeholderLabel      = placeholderLabel;
    self.delegate              = self;
    [self addSubview:placeholderLabel];
}

- (void)setupTextViewAction:(NYTextViewAction)action {
    self.textViewAction = action;
}

@end
