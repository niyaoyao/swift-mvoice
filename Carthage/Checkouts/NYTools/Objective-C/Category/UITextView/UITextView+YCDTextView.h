//
//  UITextView+YCDTextView.h
//  YouCaiPromotion
//
//  Created by NiYao on 4/22/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YCDTextViewActionType) {
    YCDTextViewActionTypeShouldBeginEditing,
    YCDTextViewActionTypeShouldEndEditing,
    YCDTextViewActionTypeBeginEditing,      /**< 开始编辑 */
    YCDTextViewActionTypeEndEditing,        /**< 结束编辑 */
    YCDTextViewActionTypeShouldChangeText,  /**< 替换字符 */
    YCDTextViewActionTypeChange,            /**< 字符串改变 */
};

typedef void (^YCDTextViewAction)(YCDTextViewActionType actionType); /**< 回调类型 */

@interface UITextView (YCDTextView)

- (void)setPlaceholderString:(NSString *)placeholderString;
/**
 *  设置 TextView 的 placeholder
 *  注：请先设置 TextView 的 frame
 *  @param placeholderString 占位字符串
 *  @param frame             提示 Label frame
*/

- (void)setupPlaceholderString:(NSString *)placeholderString
                         frame:(CGRect)frame;
/**
 *  设置回调方法，利用回调取代 UITextViewDelegate
 *
 *  @param action 回调 block @see YCDTextViewAction
 */
- (void)setupTextViewAction:(YCDTextViewAction)action;

@end
