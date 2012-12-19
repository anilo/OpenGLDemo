//
//  ViewController.m
//  GLKit3DCube
//
//  Created by Anil Punjabi on 12/16/12.
//  Copyright (c) 2012 Anil Punjabi. All rights reserved.
//
// 

#import "ViewController.h"

@interface ViewController ()

@end

#define BUFFER_OFFSET(i) ((char *)NULL + (i))


// Specify the vertices and normals needed to draw the cube
// 36 vertices are needed to draw the cube
// These represent the 6 faces of the cube
// Each face has two triangles
// Each triangle is defined by three vertices...
// Therefore we have 36 vertices to define the 6 faces of the cube
GLfloat gCubeVertexData[216] =
{
    //x     y      z              nx     ny     nz
    // front facing side of the cube
    // Triangle 1 for front facing side
    // Notice that the normal is the arrow pointing towards us -- in this case it is the z-axis (0,0,1)
    1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,    ///right top section
    -1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,    //here top left -- front facing
    1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,     // here bottom right section again
    
    // Triangle 2 of front facing side
    1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,     //here bottom right section
    -1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,    // here top left -- front facing -- again
    -1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,   //here  bottom left -- front facing
    
    
    
    // right facing side of the cube
    1.0f, -1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
    1.0f,  1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
    1.0f, -1.0f,  1.0f,         1.0f,  0.0f,  0.0f,
    1.0f, -1.0f,  1.0f,         1.0f,  0.0f,  0.0f,
    1.0f,  1.0f,  1.0f,         1.0f,  0.0f,  0.0f,    
    1.0f,  1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
    
    
    //top facing side of the cube
    1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
    1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
    1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
    
    
    // left facing side of the cube
    -1.0f,  1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,  
    
    // bottom facing side of the cube
    -1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
    1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
    -1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,  
    -1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,
    1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
    1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,
    

    
    // back side of the cube
    1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f
};


@implementation ViewController
@synthesize context;
@synthesize effect;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Assign the context to be of type EAGLContext -- and set it up for OpenGL ES2.0
    self.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create OpenGL ES 2.0 context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
    [self setUpGL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnLoad
{

    [self tearDownGL];

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}



// This method is used to specify the properties needed for OpenGL
- (void)setUpGL
{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;

    // specifies the color of each of the cube sides
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);      

    // Play with some of the other colors below to get a feel
  //  self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
  //  self.effect.light0.diffuseColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
  //  self.effect.light0.diffuseColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 0.3f);
    
    
    glEnable(GL_DEPTH_TEST);
    
    
    // The most important element to setup in the case of an OpenGl program is the vertexBuffer.
    // The following lines are used to configure the vertexBuffer.
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    // This line tells the system to read from the array gCubeVertexData to populate the vertex buffer.
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
}


// Implement tearDownGL method
// this is the cleanup class -- it is used to release the memory allocated by the vertex buffers
- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    // empty the vertex buffers
    glDeleteBuffers(1, &vertexBuffer);
    
    self.effect = nil;
}



//Implement GLKViewController method update
// This method gets called every time the image needs to be rendered on the screen.
//
// In this method we should specify the modelMatrix (which is the rotation and distance from eye as specified in x,y,z co-ordinates)
// and
// projectionMatrix ( )
// The update method is used to specify the state [ animation, physics, simulations and game logic ]
- (void)update
{
    GLKMatrix4 projectionMatrix, modelMatrix, modelMatrixFinal;
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    
    // The 1st variable --> Specifies the direction of the rotation -- anything from 0 to 180 degrees rotates it in our direction
    // anything more than 180 degrees to 360 degrees rotates it in the reverse direction
    // The 2nd variable --> specifies the ratop of the screen aspect ratio
    // The 3rd variable --> specifies the near clipping distance.
    projectionMatrix = GLKMatrix4MakePerspective (GLKMathDegreesToRadians(50.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // The translation matrix specifies how we want to position the 3D object with reference to our view
    modelMatrix = GLKMatrix4MakeTranslation(0.0f,0.0f,-9.0f);
//    modelMatrix = GLKMatrix4MakeTranslation(1.0f,1.0f,-9.0f);

    
    // Try uncommenting some of the lines below
//    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0.0f,0.0f,-7.0f);
//    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0.0f,0.0f,-7.0f);
    
    // specify the rotation along the axis.    
  //  Rotate 100% along the x-axis + 30% along y-axis + 70% along z-axis 
    modelMatrixFinal = GLKMatrix4Rotate(modelMatrix,rotation,1.0f,0.3f,0.7f);
    
// try playing with different rotation percentage along the axis from the options below
 //   modelMatrixFinal = GLKMatrix4Rotate(modelMatrix,rotation,0.0f,0.0f,0.7f); // rotate along z axis
 //   modelMatrixFinal = GLKMatrix4Rotate(modelMatrix,rotation,0.7f,0.0f,0.0f); // rotate along x axis
 //   modelMatrixFinal = GLKMatrix4Rotate(modelMatrix,rotation,0.0f,0.7f,0.0f); // rotate along y axis
    
    self.effect.transform.modelviewMatrix = modelMatrixFinal;
    
    // controls the speed of the rotation -- it automatically uses this variable
    rotation += self.timeSinceLastUpdate * 1.0f;
}


// Implement GLKView delegate method
// This is exactly the same as the drawRect method in any other regular UIViewController class
// It gets called every time a frame needs to be rendered
// The drawInRect method is used to draw the scene itself
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // specify (r,g,b, alpha) color for the various surface layers
    glClearColor(0.6f, 0.6f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    // OpenGL recommends we call prepareToDraw before actually drawing the triangles
    [self.effect prepareToDraw];
    
    // This method is used to draw the 36 triangles, which represents the cube
    // Try removing this line and your screen will go blank.
    glDrawArrays(GL_TRIANGLES, 0, 36);
}



//Add pausing functionality

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}

@end
