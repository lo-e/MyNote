//
//  NoteContainerView.m
//  PresentationLayer
//
//  Created by loe on 14-9-14.
//  Copyright (c) 2014年 hainan.university. All rights reserved.
//

#import "NoteContainerView.h"
#import "Note.h"

@interface NoteContainerView ()

@property (nonatomic, retain)UITextView *contentTextView;
@property (nonatomic, retain)UILabel *timeLabel;

@end

@implementation NoteContainerView

- (void)dealloc
{
    self.note = nil;
    self.contentTextView = nil;
    self.timeLabel = nil;
    self.attributes = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentTextView];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (id) initWithNote:(Note *)note radius:(float)radius; {

    self = [self initWithFrame:CGRectZero];
    if ( self ) {
        self.note = note;
        self.radius = radius;
    }
    return self;

}

- (UITextView *) contentTextView {

    if ( !_contentTextView ) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:12];
        _contentTextView.left = 5;
        _contentTextView.top = 5;
        _contentTextView.userInteractionEnabled = NO;
    }
    return _contentTextView;

}

- (UILabel *) timeLabel {

    if ( !_timeLabel ) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.size = CGSizeMake(200, 20);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;

}

- (void) layoutSubviews {

    //布局内容label
    _contentTextView.width = CGRectGetWidth(self.bounds)-10;
    if ( _note.content.length == 0 ) {
        _contentTextView.text = @"";
    }else {
        _contentTextView.attributedText = [NoteContainerView attributedStringToShow:_note.content range:_range attributes:_attributes];
    }
    [_contentTextView sizeToFit];
    
    //布局时间label
    _timeLabel.text = [NSString stringWithDate:_note.date];
    _timeLabel.font = [UIFont fontWithName:@"NoteWorthy" size:6];
    _timeLabel.top = _contentTextView.bottom+5;
    _timeLabel.left = 5;
    
    //设置圆角
    [self setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(_radius, _radius)];
    
}

+ (NSAttributedString *) attributedStringToShow:(NSString *)content range:(NSRange)range attributes:(NSDictionary *)attributes {

    NSAttributedString *ret = nil;
    if ( !attributes ) {
        if ( content.length <= 150 ) {
            ret = [[[NSAttributedString alloc] initWithString:content] autorelease];
        }else if ( content.length <= 500 ) {
            NSInteger len = 150 + (content.length-150)/5;
            NSString *temp = [content substringWithRange:NSMakeRange(0, len)];
            temp = [NSString stringWithFormat:@"%@..",temp];
            ret = [[[NSAttributedString alloc] initWithString:temp] autorelease];
        }else {
            NSString *temp = [content substringWithRange:NSMakeRange(0, 500)];
            temp = [NSString stringWithFormat:@"%@..",temp];
            ret = [[[NSAttributedString alloc] initWithString:temp] autorelease];
        }
    }else {
        NSMutableAttributedString *temp = [[[NSMutableAttributedString alloc] initWithString:content] autorelease];
        [temp addAttributes:attributes range:range];
        if ( content.length <= 150 ) {
            ret = temp;
        }else {
            NSInteger last = content.length - range.location+range.length;
            if ( range.location <= 150 ) {
                range = NSMakeRange(0, range.location+range.length+last/5);
            }else {
                range = NSMakeRange(range.location-150, 150+range.length+last/5);
            }
            ret = [temp attributedSubstringFromRange:range];
        }
    }
    return ret;
}

+ (float) heightForContentLabelWithNote:(Note *)note range:(NSRange)range attributes:(NSDictionary *)attributes labelWidth:(float)width {

    UITextView *textView = [[[UITextView alloc] init] autorelease];
    textView.font = [UIFont systemFontOfSize:12];
    textView.width = width-10;
    if ( note.content.length == 0 ) {
        textView.text = @"";
    }else {
        textView.attributedText = [NoteContainerView attributedStringToShow:note.content range:range attributes:attributes];
    }
    [textView sizeToFit];
    return textView.height;

}

+ (float) heightWithNote:(Note *)note range:(NSRange)range attributes:(NSDictionary *)attribues width:(float)width {

    float height = [NoteContainerView heightForContentLabelWithNote:note range:range attributes:attribues labelWidth:width];
    height += 30;
    return height;

}

@end
