LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libbase
LOCAL_C_INCLUDES := \
    system/core/base/include \
    system/core/init
LOCAL_CFLAGS := -Wall
LOCAL_SRC_FILES := init_on7xelte.cpp
LOCAL_MODULE := libinit_on7xelte
include $(BUILD_STATIC_LIBRARY)
