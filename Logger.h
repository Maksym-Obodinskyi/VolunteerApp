#ifndef LOGGER_H
#define LOGGER_H

#include <stdio.h>

#define NO_LOG          0x00
#define FAULT_LEVEL     0x01
#define ERROR_LEVEL     0x02
#define WARN_LEVEL      0x03
#define INFO_LEVEL      0x04
#define DEBUG_LEVEL     0x05
#define TRACE_LEVEL     0x06

#ifndef LOG_LEVEL
#define LOG_LEVEL   INFO_LEVEL
#endif

#include <string.h>

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#ifndef LOG_CATEGORY
  // define default log module
//  #warning "Used default log module - GENERAL"
  #define LOG_CATEGORY "GENERAL"
#endif

#define PRINTFUNCTION(format, args...) printf("%*s | %*s:%*d | " format "\n" , 25, __FILENAME__, 25, __FUNCTION__, 3, __LINE__, ##args);

#define FAULT_TAG   "FAULT "
#define ERROR_TAG   "ERROR "
#define WARN_TAG    "WARN "
#define INFO_TAG    "INFO "
#define DEBUG_TAG   "DEBUG "
#define TRACE_TAG   "TRACE "

#if LOG_LEVEL >= TRACE_LEVEL
#define TRACE()                     PRINTFUNCTION(TRACE_TAG)
#else
#define TRACE()
#endif

#if LOG_LEVEL >= DEBUG_LEVEL
#define DEBUG(message, args...)     PRINTFUNCTION(message, DEBUG_TAG, ## args)
#else
#define DEBUG(message, args...)
#endif

#if LOG_LEVEL >= INFO_LEVEL
#define INFO(message, args...)      PRINTFUNCTION(message, INFO_TAG, ## args)
#else
#define INFO(message, args...)
#endif

#if LOG_LEVEL >= WARN_LEVEL
#define WARN(message, args...)     PRINTFUNCTION(message, WARN_TAG, ## args)
#else
#define WARN(message, args...)
#endif

#if LOG_LEVEL >= ERROR_LEVEL
#define ERROR(message, args...)     PRINTFUNCTION(message, ERROR_TAG, ## args)
#else
#define ERROR(message, args...)
#endif

#if LOG_LEVEL >= NO_LOGS
#define FAULT(message, args...)     PRINTFUNCTION(message, FAULT_TAG, ## args)
#else
#define FAULT(message, args...)
#endif

#endif // LOGGER_H
