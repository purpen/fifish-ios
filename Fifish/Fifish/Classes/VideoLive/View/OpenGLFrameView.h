//
//  OpenGLFrameView.h
//  OpenGLFrameView
//
//  Created by macpro on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//





#import <UIKit/UIKit.h>
#import "FifishYUV420Data.h"

@protocol OpenGLESViewPTZDelegate;

@interface OpenGLGLRenderer_YUV : NSObject
{
    
    GLint _uniformSamplers[3];
    GLuint _textures[3];
}

- (BOOL) isValid;
- (NSString *) fragmentShader;
- (void) resolveUniforms: (GLuint) program;
- (void) setFrame: (YUV420Frame *) frame;
- (BOOL) prepareRender;

@end



@interface OpenGLFrameView : UIView
{
    EAGLContext     *_context;
    GLuint          _framebuffer;
    GLuint          _renderbuffer;
    GLint           _backingWidth;
    GLint           _backingHeight;
    GLuint          _program;
    GLint           _uniformMatrix;
    GLfloat         _vertices[8];
    
    CGPoint      begainPoint;
    

    
    OpenGLGLRenderer_YUV* _renderer;
    
}
@property (nonatomic,assign)id<OpenGLESViewPTZDelegate> openGLESViewPTZDelegate;

- (id) initWithFrame:(CGRect)frame;
- (void) render: (YUV420Frame *) frame;
- (UIImage*)snapshotPicture;
@end


@protocol OpenGLESViewPTZDelegate <NSObject>

@optional
- (void)cameraPTZ_Stop;
- (void)cameraPTZ_Left;
- (void)cameraPTZ_Right;
- (void)cameraPTZ_Up;
- (void)cameraPTZ_Down;
- (void)singleTouchOnOpenGLESView;

@end








