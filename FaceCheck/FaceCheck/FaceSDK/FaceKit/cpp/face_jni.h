
#ifndef face_jni_h
#define face_jni_h

#include "global_listener.h"

using namespace std;

void SmartDetector_bindListen(global_listener *listener);

bool SmartDetector_loadModel(string faceModelPath);

int SmartDetector_faceDetect(unsigned char *rgbData, int imageWidth, int imageHeight, FaceDetectCppMaskPoint point);

int SmartDetector_faceDetectV2(unsigned char *rgbData, int imageWidth, int imageHeight, FaceDetectCppMaskPoint point);

void SmartDetector_release();

#endif /* face_jni_h */
