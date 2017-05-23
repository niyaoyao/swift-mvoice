//
//  UITextView+NYTextView.m
//  NYDiaryOC
//
//  Created by NiYao on 4/25/16.
//  Copyright © 2016 niyao. All rights reserved.
//

#import "UITextView+TextViewSupport.h"
#import <objc/runtime.h>

const void *placeholderLabelKey = &placeholderLabelKey;
static const char *textViewActionKey   = "textViewAction";

@interface UITextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel          *placeholderLabel;
@property (nonatomic, copy  ) TextViewAction textViewAction;

@end

@implementation UITextView (TextViewSupport)

#pragma mark - Property

- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, placeholderLabelKey);
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, placeholderLabelKey, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TextViewAction)textViewAction {
    return objc_getAssociatedObject(self, textViewActionKey);
}

- (void)setTextViewAction:(TextViewAction)textViewAction {
    objc_setAssociatedObject(self, textViewActionKey, textViewAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeShouldBeginEditing);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeShouldEndEditing);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeDidBeginEditing);
    }
    self.placeholderLabel.hidden = (textView.text.length == 0) ? NO : YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeDidEndEditing);
    }
    self.placeholderLabel.hidden = (textView.text.length == 0) ? NO : YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeShouldChangeTextInRange);
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeDidChange);
    }
    self.placeholderLabel.hidden = (textView.text.length == 0) ? NO : YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeDidChangeSelection);
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeShouldInteractWithURL);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if (self.textViewAction != nil) {
        self.textViewAction(TextViewActionTypeShouldInteractWithTextAttachment);
    }
    return YES;
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    UIFont *font = self.font ? self.font : [UIFont systemFontOfSize:13];
    CGFloat margin = 5;
    CGFloat height = 20;
    CGFloat width = [placeholderString boundingRectWithSize:CGSizeMake(300, height)
                                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: font}
                                                    context:nil].size.width;
    CGRect frame = CGRectMake(margin, margin, width, height);
    [self setPlaceholderString:placeholderString frame:frame];
}

- (void)setPlaceholderString:(NSString *)placeholderString frame:(CGRect)frame {
    UILabel *placeholderLabel  = [[UILabel alloc] initWithFrame:frame];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.text      = placeholderString;
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.frame     = frame;
    placeholderLabel.font      = self.font;
    self.placeholderLabel      = placeholderLabel;
    self.delegate              = self;
    [self addSubview:placeholderLabel];
}

- (void)setupTextViewAction:(TextViewAction)action {
    self.textViewAction = action;
}

@end
