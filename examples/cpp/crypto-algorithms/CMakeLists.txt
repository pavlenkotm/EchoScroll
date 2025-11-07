cmake_minimum_required(VERSION 3.10)
project(CryptoAlgorithms)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(keccak256 keccak256.cpp)

# Optional: Add OpenSSL for additional crypto functions
# find_package(OpenSSL REQUIRED)
# target_link_libraries(keccak256 OpenSSL::Crypto)
