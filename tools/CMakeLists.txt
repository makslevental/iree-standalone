set(IREE_PACKAGE_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(IREE_PACKAGE_ROOT_PREFIX "iree::amd-aie::tools")

iree_cc_binary(
  NAME
    iree-benchmark-executable
  SRCS
    "iree-benchmark-executable-main.c"
  DEPS
    iree::base
    iree::base::internal::flags
    iree::hal
    iree::modules::hal::types
    iree::testing::benchmark
    iree::tooling::device_util
    iree::tooling::function_io
    iree::vm
  INSTALL_COMPONENT IREETools-Runtime
)

iree_cc_binary(
  NAME
    iree-convert-parameters
  SRCS
    "iree-convert-parameters-main.c"
  DEPS
    iree::base
    iree::base::internal::file_io
    iree::base::internal::flags
    iree::hal
    iree::io::formats::irpa
    iree::io::parameter_index
    iree::io::scope_map
    iree::tooling::parameter_util
  INSTALL_COMPONENT IREETools-Runtime
)

iree_cc_binary(
  NAME
    iree-cpuinfo
  SRCS
    "iree-cpuinfo.c"
  DEPS
    iree::base
    iree::base::internal::cpu
    iree::schemas::cpu_data
  INSTALL_COMPONENT IREETools-Runtime
)

iree_cc_binary(
  NAME
    iree-create-parameters
  SRCS
    "iree-create-parameters-main.c"
  DEPS
    iree::base
    iree::base::internal::file_io
    iree::base::internal::flags
    iree::hal
    iree::io::formats::irpa
    iree::io::parameter_index
    iree::io::scope_map
    iree::io::stream
  INSTALL_COMPONENT IREETools-Runtime
)

iree_cc_binary(
  NAME
    iree-run-module
  SRCS
    "iree-run-module-main.c"
  DEPS
    iree::base
    iree::base::internal::flags
    iree::hal
    iree::tooling::context_util
    iree::tooling::run_module
    iree::vm
  INSTALL_COMPONENT IREETools-Runtime
)

iree_cc_binary(
  NAME
    iree-compile
  SRCS
    "iree-compile-main.cc"
  DEPS
    iree::compiler::bindings::c::headers
    iree::compiler::API::SharedImpl
  DATA
    ${IREE_LLD_TARGET}
  HOSTONLY
  SETUP_INSTALL_RPATH
  INSTALL_COMPONENT IREETools-Compiler
)

iree_cc_binary(
  NAME
    iree-reduce
  SRCS
    "iree-reduce.cc"
  DEPS
    iree::compiler::bindings::c::headers
    iree::compiler::API::SharedImpl
  DATA
    ${IREE_LLD_TARGET}
  HOSTONLY
  SETUP_INSTALL_RPATH
  INSTALL_COMPONENT IREETools-Compiler
)

iree_cc_binary(
  NAME
    iree-opt
  SRCS
    "iree-opt-main.cc"
  DEPS
    iree::compiler::bindings::c::headers
    iree::compiler::API::SharedImpl
  DATA
    ${IREE_LLD_TARGET}
  HOSTONLY
  SETUP_INSTALL_RPATH
  INSTALL_COMPONENT IREETools-Compiler
)

iree_cc_binary(
  NAME
    iree-mlir-lsp-server
  SRCS
    "iree-mlir-lsp-server.cc"
  DEPS
    iree::compiler::bindings::c::headers
    iree::compiler::API::SharedImpl
  SETUP_INSTALL_RPATH
  INSTALL_COMPONENT IREETools-Compiler
)

iree_cc_binary(
  NAME
    iree-run-mlir
  SRCS
    "iree-run-mlir-main.cc"
  DEPS
    iree::base
    iree::base::internal::flags
    iree::compiler::bindings::c::headers
    iree::compiler::API::SharedImpl
    iree::hal
    iree::tooling::context_util
    iree::tooling::device_util
    iree::tooling::run_module
    iree::vm
  DATA
    ${IREE_LLD_TARGET}
  HOSTONLY
  SETUP_INSTALL_RPATH
  INSTALL_COMPONENT IREETools-Compiler
)

