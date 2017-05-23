//
//  UITextView+YCDTextView.m
//  YouCaiPromotion
//
//  Created by NiYao on 4/22/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

#import "UITextView+YCDTextView.h"
#import <objc/runtime.h>

static const char *placeholderLabelKey = "placeholderLabel";
static const char *textViewActionKey   = "textViewAction";

@interface UITextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel           *placeholderLabel;
@property (nonatomic, copy  ) YCDTextViewAction textViewAction;

@end

@implementation UITextView (YCDTextView)

- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, placeholderLabelKey);
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, placeholderLabelKey, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YCDTextViewAction)textViewAction {
    return objc_getAssociatedObject(self, textViewActionKey);
}

- (void)setTextViewAction:(YCDTextViewAction)textViewAction {
    objc_setAssociatedObject(self, textViewActionKey, textViewAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
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
    [self setupPlaceholderString:placeholderString frame:frame];
}
- (void)setupPlaceholderString:(NSString *)placeholderString frame:(CGRect)frame {
    UILabel *placeholderLabel  = [[UILabel alloc] initWithFrame:frame];
    placeholderLabel.text      = placeholderString;
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.frame     = frame;
    placeholderLabel.font      = self.font;
    self.placeholderLabel      = placeholderLabel;
    self.delegate              = self;
    [self addSubview:placeholderLabel];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeBeginEditing);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = (textView.text.length == 0) ? NO : YES;
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeEndEditing);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        //换行收键盘，结束编辑状态
        [textView resignFirstResponder];
    }
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeShouldChangeText);
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeChange);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeShouldBeginEditing);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textViewAction != nil) {
        self.textViewAction(YCDTextViewActionTypeShouldEndEditing);
    }
    return YES;
}

#pragma mark - Public Method

- (void)setupTextViewAction:(YCDTextViewAction)action {
    self.textViewAction = action;
}

@end
