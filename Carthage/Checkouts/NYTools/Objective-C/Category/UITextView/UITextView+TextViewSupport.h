//
//  UITextView+NYTextView.h
//  NYDiaryOC
//
//  Created by NiYao on 4/25/16.
//  Copyright © 2016 niyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TextViewSupport)

typedef NS_ENUM(NSInteger, TextViewActionType) {
    TextViewActionTypeShouldBeginEditing,
    TextViewActionTypeShouldEndEditing,
    TextViewActionTypeDidBeginEditing,
    TextViewActionTypeDidEndEditing,
    TextViewActionTypeShouldChangeTextInRange,
    TextViewActionTypeDidChange,
    TextViewActionTypeDidChangeSelection,
    TextViewActionTypeShouldInteractWithURL,
    TextViewActionTypeShouldInteractWithTextAttachment,
};

typedef void (^TextViewAction)(TextViewActionType actionType);

- (void)setPlaceholderString:(NSString *)placeholderString;

/**
 *  设置占位字符串
 *
 *  @param placeholderString 占位字符串
 *  @param frame             相对于 TextView 的位置
 */
- (void)setPlaceholderString:(NSString *)placeholderString frame:(CGRect)frame;

/**
 *  设置 TextView 回调方法
 *
 *  @param action 回调方法 @see NYTextViewAction
 */
- (void)setupTextViewAction:(TextViewAction)action;

@end
