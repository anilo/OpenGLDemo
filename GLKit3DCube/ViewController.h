//
//  ViewController.h
//  GLKit3DCube
//
//  Created by Anil Punjabi on 12/16/12.
//  Copyright (c) 2012 Anil Punjabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController{
GLuint vertexBuffer;
float rotation;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setUpGL;
- (void)tearDownGL;

@end
