find_program(SEVEN_ZIP_EXECUTABLE NAMES 7z 7za)

if (NOT SEVEN_ZIP_EXECUTABLE)
    message(FATAL_ERROR "7-Zip (7z or 7za) not found. Please install 7-Zip.")
endif ()

set(OUTPUT_LOG "${CMAKE_CURRENT_SOURCE_DIR}/7z_output.log")

set(TARGET_ZIP "${PROJECT_NAME}_${CMAKE_PROJECT_VERSION}.7z")

ADD_CUSTOM_COMMAND(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${SEVEN_ZIP_EXECUTABLE} a -t7z -mx=9 "${CMAKE_CURRENT_SOURCE_DIR}/contrib/Artifact/${TARGET_ZIP}" "${DISTRIBUTION_DIR}/*" > ${OUTPUT_LOG}
)
