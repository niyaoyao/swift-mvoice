//
//  UITextView+NYTextView.h
//  NYDiaryOC
//
//  Created by NiYao on 4/25/16.
//  Copyright © 2016 niyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (NYTextView)

typedef NS_ENUM(NSInteger, NYTextViewActionType) {
    NYTextViewActionTypeShouldBeginEditing,
    NYTextViewActionTypeShouldEndEditing,
    NYTextViewActionTypeDidBeginEditing,
    NYTextViewActionTypeDidEndEditing,
    NYTextViewActionTypeShouldChangeTextInRange,
    NYTextViewActionTypeDidChange,
    NYTextViewActionTypeDidChangeSelection,
    NYTextViewActionTypeShouldInteractWithURL,
    NYTextViewActionTypeShouldInteractWithTextAttachment,
};

typedef void (^NYTextViewAction)(NYTextViewActionType actionType);

/**
 *  设置占位字符串
 *
 *  @param placeholderString 占位字符串
 *  @param frame             相对于 TextView 的位置
 */
- (void)setupPlaceholderString:(NSString *)placeholderString frame:(CGRect)frame;

/**
 *  设置 TextView 回调方法
 *
 *  @param action 回调方法 @see NYTextViewAction
 */
- (void)setupTextViewAction:(NYTextViewAction)action;

@end
