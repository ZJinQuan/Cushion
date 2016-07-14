//
//  FaceLandTrack.hpp
//  FaceLandTrack
//
//  Created by WangSheng on 16/5/18.
//  Copyright © 2016年 ColorReco. All rights reserved.
//

#ifndef _COLOR_RECO_FACE_TRACK_HPP
#define _COLOR_RECO_FACE_TRACK_HPP

//extern "C"

int FaceDetect_ColorReco(unsigned char * gray_image_data, int width, int height,int *facebox);

int FaceAlignInit_ColorReco();
    
float FaceAlignProcess_ColorReco(unsigned  char*gray_image_data,int width,int height,int* facebox,float *landmarkpos,float *pose);
    
float FaceAlignTrackProcess_ColorReco(unsigned  char*gray_image_data,int width,int height,int* facebox,float *landmarkpos,float *pose);



// 拓展应用接口
float *GetLeftEyeShape(float *landmarkpos,int len);

float *GetRightEyeShape(float *landmarkpos,int len);

float *GetNoseLineShape(float *landmarkpos,int len);

float *GetNoseTipShape(float *landmarkpos,int len);

float *GetLeftEyeBrowShape(float *landmarkpos,int len);

float *GetRightEyeBrowShape(float *landmarkpos,int len);

float *GetMouseOutSideShape(float *landmarkpos,int len);

float *GetMouseInSideShape(float *landmarkpos,int len);

float *GetChinShape(float *landmarkpos,int len);

float GetEyeStatus(unsigned char *gray_image_data,int width,int height,float *landmark,float *eyestaus);


#endif /* FaceLandTrack_hpp */
