# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

# Included from the rocjitsu tests build so the wire client exercises the
# selected host implementation and matching generated configuration schema.
add_executable(vfio_system_cts vfio/vfio_device_host_test.cpp vfio/vfio_user_client.cpp)
rj_configure_target(vfio_system_cts TEST)
target_include_directories(vfio_system_cts PRIVATE "${CMAKE_SOURCE_DIR}/tests")
target_link_libraries(
    vfio_system_cts
    PRIVATE ${RJ_OBJECT_LIBS} rocjitsu_kmd rocjitsu_vmm_vfu libvfio-user::libvfio-user
            util flatbuffers Threads::Threads GTest::gtest_main
)
target_link_options(vfio_system_cts PRIVATE "LINKER:--wrap=vfu_run_ctx")
rj_add_test_path(vfio_system_cts RJ_VFU_TEST_CONFIG_PATH "${CMAKE_SOURCE_DIR}/configs/gfx1250_mi455x.json")
add_test(NAME SystemCTS.VfioTransport COMMAND vfio_system_cts)
set_tests_properties(SystemCTS.VfioTransport PROPERTIES LABELS "system-cts;vfio" TIMEOUT 180)

foreach(check IN ITEMS run_vfio_guest run_rccl_scaleout run_rccl_pod_emulated_node)
    add_test(
        NAME SystemCTS.Launcher.${check}
        COMMAND "${CMAKE_COMMAND}" -E env "ROCJITSU_SOURCE_DIR=${CMAKE_SOURCE_DIR}"
                "${Python3_EXECUTABLE}" -B "${CMAKE_CURRENT_SOURCE_DIR}/launchers/check_${check}.py"
    )
    set_tests_properties(SystemCTS.Launcher.${check} PROPERTIES LABELS "system-cts;launcher" TIMEOUT 180)
endforeach()
add_test(
    NAME SystemCTS.VfioSocketAliases
    COMMAND "${Python3_EXECUTABLE}" -B "${CMAKE_CURRENT_SOURCE_DIR}/launchers/check_vfio_cli.py"
            $<TARGET_FILE:rocjitsu_bin> "${CMAKE_SOURCE_DIR}/tests/fixtures/fabric_node_projection.json"
)
set_tests_properties(SystemCTS.VfioSocketAliases PROPERTIES LABELS "system-cts;vfio" TIMEOUT 15)

set(ROCJITSU_CTS_GUEST_INPUTS "" CACHE FILEPATH "JSON manifest for guest system CTS artifacts")
foreach(node RANGE 0 3)
    add_test(NAME SystemCTS.HeliosMI455X.node${node}
             COMMAND $<TARGET_FILE:rocjitsu_bin>
                     --config "${CMAKE_SOURCE_DIR}/configs/gfx1250_mi455x_kmd_4node_2gpu_if.json"
                     --node node${node} -- "${Python3_EXECUTABLE}"
                     "${CMAKE_CURRENT_SOURCE_DIR}/check_helios_node.py" ${node})
    set_tests_properties(SystemCTS.HeliosMI455X.node${node} PROPERTIES
                         LABELS "system-cts;workload;helios" RUN_SERIAL TRUE TIMEOUT 60)
endforeach()
foreach(workload IN ITEMS Network EmulatedPod GuestPeer GuestPod)
    set(guest_args "")
    if(workload MATCHES "^Guest" AND ROCJITSU_CTS_GUEST_INPUTS)
        set(guest_args --guest-inputs "${ROCJITSU_CTS_GUEST_INPUTS}")
    endif()
    add_test(
        NAME SystemCTS.${workload}
        COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_SOURCE_DIR}/run_workload.py" ${workload}
                --source "${CMAKE_SOURCE_DIR}" --rocjitsu $<TARGET_FILE:rocjitsu_bin>
                --rank "${CMAKE_BINARY_DIR}/tests/hip_rccl_gfx1250_test" ${guest_args}
    )
    set_tests_properties(SystemCTS.${workload} PROPERTIES LABELS "system-cts;workload"
                         RUN_SERIAL TRUE TIMEOUT 6000)
    if(workload MATCHES "Pod$")
        set_property(TEST SystemCTS.${workload} APPEND PROPERTY LABELS helios)
    endif()
endforeach()
