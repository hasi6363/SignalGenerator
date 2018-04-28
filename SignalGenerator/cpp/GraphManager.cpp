//
//  GraphManager.cpp
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/01.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#include "GraphManager.hpp"
#include <CoreAudio/CoreAudioTypes.h>

GraphManager::GraphManager()
{
    NewAUGraph(&mAuGraph);
    AUGraphOpen(mAuGraph);
}
GraphManager::~GraphManager()
{
    AUGraphUninitialize(mAuGraph);
    AUGraphClose(mAuGraph);
    DisposeAUGraph(mAuGraph);
}
void GraphManager::freeNode()
{
    for(auto itr = mNodeMap.begin();itr != mNodeMap.end();++itr)
    {
        free(itr->second);
    }
}
void GraphManager::initialize()
{
    AUGraphInitialize(mAuGraph);
}

AUNode* GraphManager::addNode(string key, const AudioComponentDescription* acd)
{
    AUNode* node = new AUNode();
    AUGraphAddNode(mAuGraph, acd, node);
    mNodeMap[key] = node;
    return node;
}

void GraphManager::setCallback(string key, AURenderCallbackStruct* callback_struct)
{
    AUGraphSetNodeInputCallback(mAuGraph, *mNodeMap[key], 0, callback_struct);
}

AUNode* GraphManager::getNode(string key)
{
    return mNodeMap[key];
}

void GraphManager::getAudioUnit(string key, AudioUnit* au)
{
    AUNode node = *mNodeMap[key];
    AUGraphNodeInfo(mAuGraph, node, NULL, au);
}

void GraphManager::setProperty(string key, AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement, const void *inData, UInt32 inDataSize)
{
    AudioUnit au;
    getAudioUnit(key, &au);
    AudioUnitSetProperty(au, inID, inScope, inElement, inData, inDataSize);
}

void GraphManager::setASBD(string key, AudioStreamBasicDescription* asbd)
{
    setProperty(key, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, asbd, sizeof(AudioStreamBasicDescription));
}
void GraphManager::setEnableIO(string key, UInt32 flag)
{
    setProperty(key, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &flag, sizeof(flag));
}

void GraphManager::connect(string src_key, UInt32 src_out_num, string dest_key, UInt32 dest_input_num)
{
    AUGraphConnectNodeInput(mAuGraph, *mNodeMap[src_key], src_out_num, *mNodeMap[dest_key], dest_input_num);
}
void GraphManager::start()
{
    AUGraphStart(mAuGraph);
}
void GraphManager::stop()
{
    AUGraphStop(mAuGraph);
}

